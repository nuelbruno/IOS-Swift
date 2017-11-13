//
//  SideBarViewController.swift
//  Chat
//
//  Created by Niraj Kumar on 4/25/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var sideBarMenu = [
        [
            "icon" : "icn-change-language".localized(),
            "menu" : "changeLanguage".localized()
        ],
        [
            "icon" : "icn-logout".localized(),
            "menu" : "logout".localized()
        ]
    ]
    
    @IBOutlet weak var tblviewSidebar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblviewSidebar.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
     }

    // MARK: TableView Delegate Methods
    
    /**
     Returns number of sections
     
     - parameter tableView: tblviewContacts
     
     - returns: section numbers
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Returns number of rows in the section
     
     - parameter tableView: tblviewContacts
     - parameter section:   section index
     
     - returns: number of rows
     */
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return sideBarMenu.count
    }
    
    /**
     Populate the row with proper information
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: index information
     
     - returns: tableview cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "sideBarMenu"
        let cell: SideBarMenuTVC = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SideBarMenuTVC
        cell.selectionStyle = .None
        if let button = cell.btnMenu {
            button.setImage(UIImage(named: (sideBarMenu[indexPath.row]["icon"]! as String).localized()), forState: .Normal)
        }
        
        if let label = cell.lblMenu {
            label.text = "\((sideBarMenu[indexPath.row]["menu"])! )"
        }
        
        return cell as UITableViewCell
    }
    
    /**
     Called on click of tableview row
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: indexpath information
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hideSideMenuView()
        switch indexPath.row {
        case 0:
            AppDelegate.getAppDelegate().changeLanguage()
            break
        case 1:
            NSNotificationCenter.defaultCenter().postNotificationName("Logout", object: self)
            break
        default:
            print("Default")
            break
        }
    }
}
