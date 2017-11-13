//
//  ViewController.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/12/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var requests:NSMutableArray = []
    var username: String?
    var password: String?
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "adminLogin".localized()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let userinfo: NSDictionary = AppDelegate.getAppDelegate().defaults.objectForKey("userinfo") as? NSDictionary {
            txtUsername.text = userinfo.valueForKey("UserName") as? String
            txtPassword.text = userinfo.valueForKey("Password") as? String
        }
    }
    
    /**
     Callback for login user
     
     - parameter result: Response
     */
    func loginSuccessCallback(result: AnyObject) -> Void {
        txtUsername.text = ""
        txtPassword.text = ""
        AppDelegate.getAppDelegate().defaults.setObject([
            "UserName" : username!,
            "Password" :password!
            ], forKey: "userinfo")
        requests = result as! NSMutableArray
        performSegueWithIdentifier("login", sender: self)
    }
    
    /**
     Error Callback
     
     - parameter result: anyobject
     */
    func loginErrorCallback(result: AnyObject) -> Void {
        Utility.sharedInstance.showAlert(self, title:"loginError".localized(), message: (result.objectForKey("message") as? String)!)
    }
    
    
    /**
     Called on click of login button
     
     - parameter sender:	btnLogin
     */
    @IBAction func login(sender: AnyObject) {
        username = txtUsername.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        password = txtPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if(username == ""){
            Utility.sharedInstance.showAlert(self, title: "loginError".localized(), message: "emptyUsername".localized())
        }else if(username?.isValidEmail == false){
            Utility.sharedInstance.showAlert(self, title: "loginError".localized(), message: "invalidEmailID".localized())
        }else if(password == ""){
            Utility.sharedInstance.showAlert(self, title: "loginError".localized(), message: "Please enter the password")
        }else{
            NetworkManager.sharedInstance.callWSLogin([
                "UserName" : username!,
                "Password" :password!,
                ], containerView: self.view, successCallback: loginSuccessCallback, errorCallback: loginErrorCallback)
        }
        
    }
    
    /**
     Forbid the segue to continue with the operation
     
     - parameter identifier:	segue identifier
     - parameter sender:			sender
     
     - returns: boolean false if segue is login
     */
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier.compare("login") == .OrderedSame {
            return false
        }
        return true
    }
    
    /**
     Prepare for the segue operation
     
     - parameter segue:  segue from login view controller
     - parameter sender: login button
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if requests.count > 0 {
            if segue.identifier?.compare("login") == .OrderedSame {
                let appNavigationVC: AppNavigationVC = segue.destinationViewController as! AppNavigationVC
                let requestsVC: RequestsVC = appNavigationVC.topViewController as! RequestsVC
                requestsVC.requests = requests
            }
        }
    }
    
    
}

