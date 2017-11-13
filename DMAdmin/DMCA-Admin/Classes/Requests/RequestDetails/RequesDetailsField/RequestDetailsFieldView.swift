//
//  RequestFieldView.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/22/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestDetailsFieldView: UIView {

    // Our custom view from the XIB file
    var view: UIView!
    var isEnglish: Bool = AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame
    
    // English
    
    @IBOutlet weak var lblFieldHeader: UILabel!
    @IBOutlet weak var btnFieldValue: UIButton!
    
    // Arabic
    @IBOutlet weak var lblFieldHeader_ar: UILabel!
    @IBOutlet weak var btnFieldValue_ar: UIButton!
    
    var onBtnValueClicked : ((sender: RequestDetailsFieldView, value:String) -> Void)? = nil
    
    @IBInspectable var index: Int {
        get {
            return view.tag
        }
        set(number) {
            view.tag = index
        }
    }
    
    @IBInspectable var bgcolor: String? {
        get {
            return self.bgcolor
        }
        set(bgc) {
            view.backgroundColor = UIColor(rgba: bgc!)
        }
    }
    
    @IBInspectable var header: String? {
        get {
            return (isEnglish) ? lblFieldHeader.text : lblFieldHeader_ar.text
        }
        set(text) {
            lblFieldHeader_ar.text = text
            lblFieldHeader.text = text
        }
    }
    
    @IBInspectable var value: String? {
        get {
            return (isEnglish) ? btnFieldValue.titleLabel!.text : btnFieldValue_ar.titleLabel!.text
        }
        set(text) {
            btnFieldValue.setTitle(text, forState: .Normal)
            btnFieldValue_ar.setTitle(text, forState: .Normal)
        }
    }
    
    
    @IBAction func btnFieldValueClicked(sender: AnyObject) {
        if let onBtnValueClicked = self.onBtnValueClicked {
            onBtnValueClicked(sender: self, value: self.value!)
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
        let nib = UINib(nibName: "RequestDetailsFieldView", bundle: bundle)
        
        // Assumes UIView is top level and only object in RequestDetailsFieldView file
        let view = nib.instantiateWithOwner(self, options: nil)[(isEnglish ? 0 : 1)] as! UIView
        return view
    }
    
}
