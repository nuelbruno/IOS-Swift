//
//  RequestFieldView.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/22/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestFieldView: UIView {

    // Our custom view from the XIB file
    var view: UIView!
    var isEnglish: Bool = AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame
    
    // English
    
    @IBOutlet weak var lblFieldHeader: UILabel!
    @IBOutlet weak var lblFieldValue: UILabel!
    @IBOutlet weak var imgDetails: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    var onMoreBtnTapped : ((sender: RequestFieldView, rowIndex:NSInteger) -> Void)? = nil
    
    // Arabic
    @IBOutlet weak var lblFieldHeader_ar: UILabel!
    @IBOutlet weak var lblFieldValue_ar: UILabel!
    @IBOutlet weak var imgDetails_ar: UIImageView!
    
    @IBOutlet weak var btnMore_ar: UIButton!
    
    @IBAction func btnMoreClicked(sender: AnyObject) {
        if let onMoreBtnTapped = self.onMoreBtnTapped {
            onMoreBtnTapped(sender: self, rowIndex: self.index)
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
    
    @IBInspectable var fieldIndex: Int {
        get {
            return (isEnglish) ? lblFieldHeader.tag : lblFieldHeader_ar.tag
        }
        set(number) {
            lblFieldHeader_ar.tag = number
            lblFieldHeader.tag = number
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
            return (isEnglish) ? lblFieldValue.text : lblFieldValue_ar.text
        }
        set(text) {
            lblFieldValue_ar.text = text
            lblFieldValue.text = text
        }
    }
    
    @IBInspectable var moreHidden: Bool? {
        get {
            return (isEnglish) ? btnMore.hidden  : btnMore_ar.hidden
        }
        set(hidden) {
            if (hidden == true) {
                lblFieldValue_ar.textColor = UIColor(rgba: "#898989")
                lblFieldValue.textColor = UIColor(rgba: "#898989")
                imgDetails.image = nil
                imgDetails_ar.image = nil
            }else{
                lblFieldValue_ar.textColor = UIColor(rgba: "#4A6A95")
                lblFieldValue.textColor = UIColor(rgba: "#4A6A95")
                imgDetails.image = UIImage(named: (isEnglish) ? "icn-arrow-right" : "icn-arrow-left")
                imgDetails_ar.image = UIImage(named: (isEnglish) ? "icn-arrow-right" : "icn-arrow-left")
            }
            
            btnMore_ar.hidden = hidden!
            btnMore.hidden = hidden!
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
        let nib = UINib(nibName: "RequestFieldView", bundle: bundle)
        
        // Assumes UIView is top level and only object in RequestFieldView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[(isEnglish ? 0 : 1)] as! UIView
        view.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)
        return view
    }
    
}
