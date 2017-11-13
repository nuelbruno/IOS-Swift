//
//  UIView+Extended.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/16/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import ObjectiveC

extension UIView{
    
    var borderColor : UIColor? {
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
    
    var backgroundGradientColor : String {
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
            
            let backgroundImage = UIImageView(frame: frame)
            backgroundImage.image = image
            self.insertSubview(backgroundImage, atIndex: 0)
            self.clipsToBounds = true
        }
    }
    
    var bottomLeftRightCorner : CGFloat {return self.bottomLeftRightCorner}
    
    func setBottomLeftRightCorner (bottomLeftRightCorner: CGFloat) -> Void {
        let maskPath = UIBezierPath.init(roundedRect: self.frame, byRoundingCorners: [.BottomLeft, .BottomRight] , cornerRadii: CGSize(width: bottomLeftRightCorner, height: bottomLeftRightCorner))
        let maskLayer = CAShapeLayer(layer: self.layer)
        maskLayer.frame = self.frame
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }

    
    var topLeftRightCorner : CGFloat {return self.topLeftRightCorner}
    
    func setTopLeftRightCorner (topLeftRightCorner: CGFloat) -> Void {
        let maskPath = UIBezierPath.init(roundedRect: self.frame, byRoundingCorners: [.TopLeft, .TopRight] , cornerRadii: CGSize(width: topLeftRightCorner, height: topLeftRightCorner))
        let maskLayer = CAShapeLayer(layer: self.layer)
        maskLayer.frame = self.frame
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }

}