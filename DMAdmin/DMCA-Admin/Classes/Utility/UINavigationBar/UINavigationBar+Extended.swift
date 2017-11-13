//
//  UINavigationBar+Extended.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/21/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    override var backgroundGradientColor : String {
        get {
            return self.backgroundGradientColor
        }
        set {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = (self.bounds)
            gradientLayer.colors = [UIColor(rgba:"#0091cf"), UIColor(rgba:"#084d82")].map{$0.CGColor}
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            // Render the gradient to UIImage
            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Set the UIImage as background property
            self.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
            
            // Set the title text color
            self.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        }
    }
}