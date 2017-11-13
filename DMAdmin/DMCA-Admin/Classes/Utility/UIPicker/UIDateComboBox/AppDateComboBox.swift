//
//  AppComboBox.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/24/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class AppDateComboBox: UIView {
    var view: UIView!
    var selectedDate: NSString?
    let dateFormatter = NSDateFormatter()
    let newDateFormatter = NSDateFormatter()
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var btnDone_ar: UIBarButtonItem!
    @IBOutlet weak var btnCancel_ar: UIBarButtonItem!
    @IBOutlet weak var datePickerView_ar: UIDatePicker!
    
    
    var onBtnCancelled : ((sender:AnyObject, value: AnyObject?) -> Void)? = nil
    var onBtnDone : ((sender:AnyObject, value: AnyObject?) -> Void)? = nil
    
    var isEnglish: Bool = AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame
    
    
    
    @IBAction func btnDoneClicked(sender: AnyObject) {
        if let onBtnDone = self.onBtnDone {
            onBtnDone(sender: sender, value: selectedDate)
        }
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        if let onBtnCancelled = self.onBtnCancelled {
            onBtnCancelled(sender: sender, value: selectedDate)
        }
    }
    
    @IBAction func btnClearClicked(sender: AnyObject) {
        if let onBtnDone = self.onBtnDone {
            onBtnDone(sender: sender, value: "")
        }
    }
    
    @IBAction func dateSelected(sender: AnyObject) {
        if isEnglish {
            self.selectedDate = newDateFormatter.stringFromDate(datePickerView.date)
        }else {
            self.selectedDate = newDateFormatter.stringFromDate(datePickerView_ar.date)
        }
    }
    
    @IBInspectable var dateString: String {
        get {
            if selectedDate == nil {
              return ""
            }
            return selectedDate! as String
        }
        set(datestr) {
            if datestr.isEmpty == false && newDateFormatter.dateFromString(datestr) != nil {
                self.selectedDate = datestr
            }else{
                self.selectedDate = newDateFormatter.stringFromDate(NSDate())
            }
            self.datePickerView_ar.date = newDateFormatter.dateFromString(self.selectedDate as! String)!
            self.datePickerView.date = newDateFormatter.dateFromString(self.selectedDate as! String)!
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        dateFormatter.dateFormat = "MM/dd/yyyy"
        newDateFormatter.dateFormat = "yyyy-MM-dd"
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
        let nib = UINib(nibName: "AppDateComboBox", bundle: bundle)
        
        // Assumes UIView is top level and only object in AppDateComboBox.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[(isEnglish ? 0 : 1)] as! UIView
        return view
    }
    
}
