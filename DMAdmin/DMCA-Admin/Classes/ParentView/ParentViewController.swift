//
//  ParentViewController.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 4/20/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit
import Localize_Swift
import UIColor_Hex_Swift
import ENSwiftSideMenu

class ParentViewController: UIViewController, ENSideMenuDelegate, UITextFieldDelegate {
    
    /**
     Called on successfully view load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ParentViewController.changeLanguage), name: LCLLanguageChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ParentViewController.logout), name: "Logout", object: nil)
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Called on memory issue
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Close the current view controller
     */
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func goBack(sender: AnyObject) {
        goBack()
    }
    
    func changeLanguage(){
    }
    
    func logout() -> Void {
        AppDelegate.getAppDelegate().defaults.setObject(nil, forKey: "userinfo")
        AppDelegate.getAppDelegate().loadMainStoryBoard(AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame ? "Main" : "Main_ar")
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        self.view.userInteractionEnabled = false
    }
    
    func sideMenuWillClose() {
        self.view.userInteractionEnabled = true
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
