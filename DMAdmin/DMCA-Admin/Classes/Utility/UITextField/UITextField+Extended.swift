//
//  UITextField+Extended.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/15/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    var customLeftInset: CGFloat {
        get {
            return self.customLeftInset
        }
        set (insetValue) {            
            let cgrect:CGRect = self.bounds
            self.textRectForBounds(self.bounds)
            self.editingRectForBounds(CGRect(x: cgrect.origin.x, y:  cgrect.origin.y, width: cgrect.width - insetValue, height: cgrect.height))
        }
    }

    var customRightInset: CGFloat {
        get {
            return self.customRightInset
        }
        set (insetValue) {
            
            let cgrect:CGRect = self.bounds
            self.textRectForBounds(self.bounds)
            self.editingRectForBounds(CGRect(x: cgrect.origin.x + insetValue, y:  cgrect.origin.y, width: cgrect.width - insetValue, height: cgrect.height))
        }
    }

    
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
}