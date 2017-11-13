//
//  UIButton+Extended.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/15/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    override var borderColor : UIColor? {
        get {
            if let cgcolor = layer.borderColor {
                return UIColor(CGColor: cgcolor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.CGColor
            
            // width must be at least 1.0
            if layer.borderWidth < 1.0 {
                layer.borderWidth = 1.0
            }
        }
    }
    
    override var backgroundGradientColor : String {
        get {
            return self.backgroundGradientColor
        }
        set {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor(rgba:"#0091cf"), UIColor(rgba:"#084d82")].map{$0.CGColor}
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            // Render the gradient to UIImage
            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.setBackgroundImage(image, forState: .Normal)
            self.clipsToBounds = true
        }
    }
}