//
//  AppActivityIndicator.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 4/20/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit
import KOActivityIndicator

class AppActivityIndicator: UIView {
    
    static let sharedInstance = AppActivityIndicator()

    func showLoader(containerView: UIView, message: String) {
        let activity = KOActivityIndicator(frame: containerView.frame)
        activity.style = .SpinInEnd
        activity.dotsColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        activity.tintColor = UIColor.purpleColor().colorWithAlphaComponent(0.8)
        activity.tag = 999;
        activity.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let msgLabel = UILabel(frame: CGRectMake(0, 0, activity.frame.width, 21))
        msgLabel.center = CGPointMake(containerView.center.x, containerView.center.y + 50.0)
        msgLabel.textAlignment = NSTextAlignment.Center
        msgLabel.text = message
        msgLabel.textColor = UIColor(rgba: "#FFFFFF").colorWithAlphaComponent(0.8)
        activity.addSubview(msgLabel)
        
        containerView.addSubview(activity)
        activity.startAnimating()
    }
    
    func hideLoader(containerView: UIView) {
        if let view = containerView.viewWithTag(999) {
            view.removeFromSuperview()
        }
        else {
            print("tag not found")
        }
    }

}
