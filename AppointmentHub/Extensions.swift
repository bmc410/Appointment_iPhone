//
//  Extensions.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 9/28/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit


    
extension Date {

    func ToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    static public func <(a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedAscending
    }
    
    static public func ==(a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedSame
    }

}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIView {

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }

}
