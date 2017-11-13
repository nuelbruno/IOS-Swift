//
//  AppAlertViewController.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 4/21/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class AppAlertViewController: UIViewController {
    
    
    @IBOutlet weak var btnOkLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOkCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewAlertBox: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var txtviewAlertMessage: UITextView!
    @IBOutlet weak var btnCancel: UIButton!
    
    var alertTitle: String?
    var alertMessage: String?
    var isCancelHidden: Bool = true
 
    var onOkBtnTapped : ((sender:AnyObject) -> Void)? = nil
    var onCancelBtnTapped : ((sender:AnyObject) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (alertTitle?.isEmpty) != nil{
            lblAlertTitle.text = alertTitle
        }else{
            lblAlertTitle.text =  NSLocalizedString("DMCA", comment: "comment")
        }
        
        
        if (alertMessage?.isEmpty) != nil{
            txtviewAlertMessage.text = alertMessage
        }else{
            txtviewAlertMessage.text = "Chat App"
        }
        
        btnCancel.hidden = isCancelHidden
        if isCancelHidden {
            btnOkLeadingConstraint.priority = 99
            btnOkCenterConstraint.priority = 100
        }else {
            btnOkLeadingConstraint.priority = 100
            btnOkCenterConstraint.priority = 99
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            if self.onCancelBtnTapped != nil {
                self.onCancelBtnTapped!(sender: sender)
            }
        }
    }
    
    @IBAction func hideAlertView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            if self.onOkBtnTapped != nil {
                self.onOkBtnTapped!(sender: sender)
            }
        }
    }
    
    

}
