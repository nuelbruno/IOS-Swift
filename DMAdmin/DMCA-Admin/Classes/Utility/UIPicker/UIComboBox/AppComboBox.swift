//
//  AppComboBox.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/24/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class AppComboBox: UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    // Our custom view from the XIB file
    var view: UIView!
    var values: NSArray?
    var selectedRow: Int = -1
    let pframe:CGRect?
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var btnDone_ar: UIBarButtonItem!
    @IBOutlet weak var btnCancel_ar: UIBarButtonItem!
    @IBOutlet weak var pickerView_ar: UIPickerView!
    
    var onBtnCancelled : ((sender:AnyObject, index: Int?, value: AnyObject?) -> Void)? = nil
    var onBtnDone : ((sender:AnyObject, index: Int?, value: AnyObject?) -> Void)? = nil
    
    var isEnglish: Bool = AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame
    
    
    @IBAction func btnClearClicked(sender: AnyObject) {
        if let onBtnDone = self.onBtnDone {
            onBtnDone(sender: sender, index: -1, value: "")
        }
    }
    
    @IBAction func btnDoneClicked(sender: AnyObject) {
        if let onBtnDone = self.onBtnDone {
            if selectedRow != -1 {
                onBtnDone(sender: sender, index: selectedRow, value: values![selectedRow])
            }else {
                onBtnDone(sender: sender, index: selectedRow, value: "")
            }
        }
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        if let onBtnCancelled = self.onBtnCancelled {
            onBtnCancelled(sender: sender, index: selectedRow, value: "")
        }
    }

    @IBInspectable var selectedValue: Int {
        get {
            return selectedRow
        }
        set(svalue) {
            self.selectedRow = svalue
            self.pickerView.selectRow(svalue, inComponent: 0, animated: true)
            self.pickerView_ar.selectRow(svalue, inComponent: 0, animated: true)
        }
    }
    
    
    @IBInspectable var data: NSArray {
        get {
            return values!
        }
        set(values) {
            self.values = data
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        pframe = frame
        // 2. call super.init(frame:)
        super.init(frame: frame)

        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        pframe = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 25.0)
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
        let nib = UINib(nibName: "AppComboBox", bundle: bundle)
        
        // Assumes UIView is top level and only object in AppComboBox.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[(isEnglish ? 0 : 1)] as! UIView
        return view
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values!.count
    }
    
    //MARK: Delegates
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return values![row] as? String
//    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        //        if let onBtnDone = self.onBtnDone {
        //            selectedRow = row
        //            onBtnDone(sender: pickerView, index: row, value: values![selectedRow])
        //        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pview = UIView(frame: CGRectMake(0,0, pframe!.size.width,20))
        let label = UILabel(frame:CGRectMake(0,0, pframe!.size.width, 18))
        pview.addSubview(label)
        label.text = values![row] as? String
        label.textAlignment = .Center
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        return pview
    }
}
