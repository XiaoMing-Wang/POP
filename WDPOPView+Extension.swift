//
//  WDPOPAnimation.swift
//  HiTalk
//
//  Created by imMac on 2021/3/22.
//  Copyright © 2021 hitalk. All rights reserved.
//

import UIKit

extension UIView {
        
    /// 放大缩小动画
    /// - Parameters:
    ///   - proportionX: proportionX
    ///   - proportionY: proportionY
    func pop_narrow(proportionX: CGFloat, proportionY: CGFloat? = nil, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        let proportionYY = proportionY ?? proportionX
        let toValue = NSValue(cgPoint: CGPoint(x: proportionX, y: proportionYY))
        pop_basic(propertyNamed: kPOPViewScaleXY, duration: duration, toValue: toValue, complete: complete)
    }

    /// frame动画
    /// - Parameters:
    ///   - frame: frame
    ///   - duration: duration
    ///   - complete: complete
    func pop_frame(frame: CGRect, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        let toValue = NSValue(cgRect: frame)
        pop_basic(propertyNamed: kPOPViewFrame, duration: duration, toValue: toValue, complete: complete)
    }
        
    /// 唯一offy
    ///   -
    /// - Parameters:
    ///   - duration: duration
    ///   - toValue: toValue
    ///   - complete: complete
    func pop_contentOffset(duration: TimeInterval, toValue: CGPoint = .zero, complete: ((Bool) -> ())? = nil) {
        guard self is UIScrollView else { return }
        pop_basic(propertyNamed: kPOPScrollViewContentOffset, duration: duration, toValue: toValue, complete: complete)
    }
    
    /// 位移
    /// - Parameters:
    ///   - duration: duration
    ///   - x: x
    ///   - y: y
    ///   - complete: complete
    func pop_contentOffset(duration: TimeInterval, x: CGFloat = 0, y: CGFloat = 0, complete: ((Bool) -> ())? = nil) {
        guard self is UIScrollView else { return }
        let point = CGPoint(x: x, y: y)
        pop_basic(propertyNamed: kPOPScrollViewContentOffset, duration: duration, toValue: point, complete: complete)
    }

    /// 透明动画
    /// - Parameters:
    ///   - alpha: alpha
    ///   - duration: duration
    ///   - complete: complete
    func pop_alpha(alpha: Double, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        pop_basic(propertyNamed: kPOPViewAlpha, duration: duration, toValue: NSNumber(value: alpha), complete: complete)
    }

    /// x轴位移
    /// - Parameters:
    ///   - toValue: toValue
    ///   - duration: duration
    ///   - complete: complete
    func pop_positionX(toValue: Double, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        pop_basic(propertyNamed: kPOPLayerPositionX, duration: duration, toValue: NSNumber(value: toValue), complete: complete)
    }

    /// y轴位移
    /// - Parameters:
    ///   - toValue: toValue
    ///   - duration: duration
    ///   - complete: complete
    func pop_positionY(toValue: Double, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        pop_basic(propertyNamed: kPOPLayerPositionY, duration: duration, toValue: NSNumber(value: toValue), complete: complete)
    }

    /// center
    /// - Parameters:
    ///   - toValue: toValue
    ///   - duration: duration
    ///   - complete: complete
    func pop_position(toValue: CGPoint, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        let toValue = NSValue(cgPoint: toValue)
        pop_basic(propertyNamed: kPOPLayerPosition, duration: duration, toValue: toValue, complete: complete)
    }
    
    /// 颜色
    /// - Parameters:
    ///   - color: color
    ///   - duration: duration
    ///   - complete: complete
    func pop_color(color: UIColor, duration: TimeInterval, complete: ((Bool) -> ())? = nil) {
        pop_basic(propertyNamed: kPOPViewBackgroundColor, duration: duration, toValue: color, complete: complete)
    }

    /// 旋转
    /// - Parameter toValue: Double.pi / 4
    func pop_rotate(toValue: Double = (Double.pi / 4)) {
        guard let transformTopAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation) else { return }
        transformTopAnimation.toValue = NSNumber(value: toValue)
        layer.pop_add(transformTopAnimation, forKey: "rotateTopAnimation")
    }
            
}


extension UIView {
    
    /// 基础动画
    /// - Parameters:
    ///   - propertyNamed: 动画名
    ///   - duration: 时间
    ///   - toValue: 目标value NSValue
    ///   - complete: 完成回调
    func pop_basic(propertyNamed: String, duration: TimeInterval, toValue: Any, complete: ((Bool) -> ())? = nil) {
        guard let basicAnimation = POPBasicAnimation(propertyNamed: propertyNamed) else { return }

        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        basicAnimation.beginTime = CACurrentMediaTime() + 0.0
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        basicAnimation.completionBlock = { (animation, finsih) in
            if finsih { complete?(finsih) }
        }
        pop_add(basicAnimation, forKey: "basic")
    }

    /// 弹簧动画
    /// - Parameters:
    ///   - propertyNamed: 动画名
    ///   - springSpeed: 速度 0-20 默认10
    ///   - springBounciness: 回弹幅度 0-20 默认4
    ///   - toValue: 目标value
    ///   - complete: 完成回调
    func pop_spring(propertyNamed: String, springSpeed: CGFloat, springBounciness: CGFloat, toValue: Any, complete: ((Bool) -> ())? = nil) {
        guard let spring = POPSpringAnimation(propertyNamed: propertyNamed) else { return }
        spring.springSpeed = springSpeed
        spring.springBounciness = springBounciness
        spring.toValue = toValue
        spring.completionBlock = { (animation, finsih) in
            if finsih { complete?(finsih) }
        }
        pop_add(spring, forKey: "spring")
    }
    
    /// 减速动画
    /// - Parameters:
    ///   - propertyNamed: 动画名
    ///   - velocity: <#velocity description#>
    ///   - complete: 完成回调
    func pop_decay(propertyNamed: String, velocity: CGFloat, complete: ((Bool) -> ())? = nil) {
        guard let decay = POPDecayAnimation(propertyNamed: propertyNamed) else { return }
        decay.velocity = NSNumber(value: Double(velocity) * 2.026089)
        decay.deceleration = 0.998
        decay.completionBlock = { (animation, finsih) in
            if finsih { complete?(finsih) }
        }
        pop_add(decay, forKey: "decay")
    }
    
    /// 自定义动画
    /// - Parameters:
    ///   - fromValue: fromValue
    ///   - toValue: toValue
    ///   - duration: duration
    ///   - complete: complete
    func pop_custom(fromValue: Any, toValue: Any, duration: TimeInterval, complete: ((CGFloat) -> ())? = nil) {
        guard let anBasic = POPBasicAnimation.linear() else { return }
        let property = POPAnimatableProperty.property(withName: "count") { (prop) in
            prop?.writeBlock = { obj, values in
                guard let values = values else { return }
                complete?(values[0])
            }
        }

        anBasic.property = property as? POPAnimatableProperty
        anBasic.fromValue = fromValue
        anBasic.toValue = toValue
        anBasic.duration = duration
        anBasic.beginTime = CACurrentMediaTime() + 0.0
        pop_add(anBasic, forKey: "anBasic")
    }

}
