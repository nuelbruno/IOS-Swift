//
//  RequestActionsView.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/23/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestActionsView: UIView {
    
    // Our custom view from the XIB file
    var view: UIView!
    
    
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    @IBOutlet weak var btnApprove_ar: UIButton!
    @IBOutlet weak var btnReject_ar: UIButton!
    
    var onBtnApprovedTapped : ((sender:AnyObject, index: Int, status: String) -> Void)? = nil
    var onBtnRejectedTapped : ((sender:AnyObject, index: Int, status: String) -> Void)? = nil
    
    var isEnglish: Bool = AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame
    
    
    
    @IBAction func btnApprove(sender: AnyObject) {
        if let onBtnApprovedTapped = self.onBtnApprovedTapped {
            onBtnApprovedTapped(sender: sender, index: index, status: "Approved")
        }
    }
    
    @IBAction func btnReject(sender: AnyObject) {
        if let onBtnRejectedTapped = self.onBtnRejectedTapped {
            onBtnRejectedTapped(sender: sender, index: index, status: "Rejected")
        }
    }
    
    @IBAction func btnApprove_ar(sender: AnyObject) {
        if let onBtnApprovedTapped = self.onBtnApprovedTapped {
            onBtnApprovedTapped(sender: sender, index: index, status: "Approved")
        }
    }
    
    @IBAction func btnReject_ar(sender: AnyObject) {
        if let onBtnRejectedTapped = self.onBtnRejectedTapped {
            onBtnRejectedTapped(sender: sender, index: index, status: "Rejected")
        }
    }
    
    @IBInspectable var index: Int {
        get {
            return view.tag
        }
        set(number) {
            view.tag = index
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RequestActionsView", bundle: bundle)
        
        // Assumes UIView is top level and only object in RequestActionsView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[(isEnglish ? 0 : 1)] as! UIView
        return view
    }
}
