//
//  ForgotPasswordVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/21/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    var username:String?
    
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var txtEmailID: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Callback for login user
     
     - parameter result: Response
     */
    func forgotPasswordSuccessCallback(result: AnyObject) -> Void {
        if let response = result as? NSMutableArray {
            self.txtEmailID.text = ""
            Utility.sharedInstance.showAlert(self, title: "forgotPassword".localized(), message: response.objectAtIndex(0) as! String)
        }
    }
    
    /**
     Error Callback
     
     - parameter result: anyobject
     */
    func forgotPasswordErrorCallback(result: AnyObject) -> Void {
        Utility.sharedInstance.showAlert(self, title:"forgotPasswordError".localized(), message: (result.objectForKey("message") as? String)!)
    }
    
    @IBAction func submitBtnClicked(sender: AnyObject) {
        username = txtEmailID.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if(username == ""){
            Utility.sharedInstance.showAlert(self, title: "forgotPasswordError".localized(), message: "emptyEmailID".localized())
        }else if(username?.isValidEmail == false){
            Utility.sharedInstance.showAlert(self, title: "forgotPasswordError".localized(), message: "invalidEmailID".localized())
        } else{
            NetworkManager.sharedInstance.callWSForgotPassword([
                "EmailAddress" : username!
                ], containerView: self.view, successCallback: forgotPasswordSuccessCallback, errorCallback: forgotPasswordErrorCallback)
        }
    }
    
}
