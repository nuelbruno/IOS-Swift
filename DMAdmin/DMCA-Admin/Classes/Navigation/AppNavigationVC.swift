//
//  AppNavigationVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/19/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class AppNavigationVC: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sidebarVC: SideBarViewController = Utility.sharedInstance.getViewControllerFromStoryboard("SideBarViewController") as! SideBarViewController
        sidebarVC.view.backgroundGradientColor = "linear"
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: sidebarVC, menuPosition: (AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame) ? .Left : .Right, blurStyle: .Dark)
        sideMenu?.menuWidth = (self.view.frame.size.width) * 0.6
        sideMenu?.animationDuration = 0.8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
