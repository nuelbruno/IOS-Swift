//
//  RequestDetailsViewController.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/18/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestDetailsVC: ParentViewController {
    
    var initialSelectedIndex: Int = 0
    let unselectedCellHeight: CGFloat = 45.0
    var selectedCellIndexPath: NSIndexPath?
    
    var requestDetails:NSMutableDictionary?
    var requestDetailsField = [
        "requestDetails",
        "SkipperDetails",
        "CraftDetails",
        "EmgContactDtails"
    ]
    let isEnglish:Bool = (AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame)
    var rdFields: [String] = [] // Request Details
    var sdFields: [String] = [] // Skipper Details
    var cdFields: [String] = [] // Craft Details
    var ecdFields: [String] = [] // Emergency Contact Details
    
    @IBOutlet weak var tblviewRequestDetails: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEnglish{}else{
            self.navigationItem.hidesBackButton = true
        }
        self.title = "requestDetails".localized()
        print(initialSelectedIndex)
        rdFields = [
            "refNumber",
            "CreatedByStr",
            "CreatedDateFormatted",
            "EndDateFormatted",
            "Duration",
            "JourneyPurpose",
            "Destination",
            "CrewMemberNames",
            "NumberOfCrews",
            "PassengerNames",
            "NumberOfPassengers",
            "Remarks",
            (isEnglish) ? "RequestStatusEn" : "RequestStatusAr",
            "ActionReason",
            "ApprovalDateFormatted",
            "SailingCoordinatesAx",
            "SailingCoordinatesAy",
            "SailingCoordinatesBx",
            "SailingCoordinatesBy",
            "SailingCoordinatesCx",
            "SailingCoordinatesCy"
        ]
        
        sdFields = [
            "FirstName",
            "LastName",
            "DateOfBirthFormatted",
            "PhoneNumber",
            "Email",
            "Country",
            "City",
            "Address"
        ]
        
        cdFields = [
            (isEnglish) ? "MarineName" : "MarineArName",
            (isEnglish) ? "MarineCraftLisenseTypeEn" : "MarineCraftLisenseTypeAr",
            (isEnglish) ? "MarineCraftCategoryStr" : "MarineCraftCategoryArStr",
            (isEnglish) ? "MarineCraftSubCategoryStr" : "MarineCraftSubCategoryArStr",
            "marineCraftPlateNumber"
        ]
        
        ecdFields = [
            "FirstName",
            "LastName",
            (isEnglish) ? "Relationship" : "RelationshipAr",
            "PhoneNumber"
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return requestDetailsField.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedCellIndexPath == nil && indexPath.row == initialSelectedIndex {
            selectedCellIndexPath = NSIndexPath(forRow: initialSelectedIndex, inSection: 0)
            initialSelectedIndex = -1
            return (CGFloat(rdFields.count) * 25.0) + 55.0
        }
        
        if selectedCellIndexPath == indexPath {
            switch indexPath.row {
            case 0:
                return (CGFloat(rdFields.count) * 25.0) + 55.0
            case 1:
                return (CGFloat(sdFields.count) * 25.0) + 50.0
            case 2:
                return (CGFloat(cdFields.count) * 25.0) + 50.0
            case 3:
                return (CGFloat(ecdFields.count) * 25.0) + 50.0
            default:
                return unselectedCellHeight
            }
        }
        return unselectedCellHeight
    }
    
    /**
     Populate the row with proper information
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: index information
     
     - returns: tableview cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "requestDetailsCell"
        let cell: RequestDetailsTVC = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RequestDetailsTVC
        cell.selectionStyle = .None
        if let label = cell.lblHeader {
            label.text = requestDetailsField[indexPath.row].localized()
        }
        
        if selectedCellIndexPath == indexPath {
            cell.vccHeightConstraint98.priority = 100
            cell.vccHeightConstraint95.priority = 99
            cell.btnExpand.setImage(UIImage(named: "icn-dropdown-up"), forState: .Normal)
        }else {
            cell.btnExpand.setImage(UIImage(named: "icn-dropdown-down"), forState: .Normal)
            cell.vccHeightConstraint98.priority = 99
            cell.vccHeightConstraint95.priority = 100
        }
        
        cell.viewDetailsContainer.subviews.forEach { $0.removeFromSuperview() }
        var viewFieldBGColor = "#E7ECF2"
        var top:CGFloat = 0.0
        
        if indexPath.row == 0 {
            for key in rdFields {
                let refView:RequestDetailsFieldView = RequestDetailsFieldView(frame: CGRect(x: 0, y: top, width: cell.bounds.size.width * 0.95, height: 25.0))
                viewFieldBGColor = ((viewFieldBGColor.compare("#FFFFFF") == .OrderedSame) ? "#E7ECF2" : "#FFFFFF")
                refView.bgcolor = viewFieldBGColor
                refView.header = key.localized()
                
                if key.compare("Duration") == .OrderedSame {
                    refView.value = Utility.sharedInstance.getDuration(requestDetails?.valueForKey("CreatedDateFormatted") as! String, endDate: requestDetails?.valueForKey("EndDateFormatted") as! String)
                }else if let value = requestDetails?.valueForKey(key) as? String{
                    refView.value = value
                }else if let value = requestDetails?.valueForKey(key) as? Double {
                    if value % 1 > 0 {
                        refView.value = "\(value)"
                    }else {
                        refView.value = "\(requestDetails?.valueForKey(key) as!  Int)"
                    }
                }
                cell.viewDetailsContainer.addSubview(refView)
                // Separator
                let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top, width: refView.frame.width, height: 1.0))
                viewSeparator.backgroundColor = UIColor(rgba: "#CFD4D9")
                cell.viewDetailsContainer.addSubview(viewSeparator)
                top += 25.0
            }
        } else if indexPath.row == 1 {
            let skipperDetails:NSDictionary = requestDetails?.objectForKey("SkipperDetails") as! NSDictionary
            for sdkey in sdFields {
                let refView:RequestDetailsFieldView = RequestDetailsFieldView(frame: CGRect(x: 0, y: top, width: cell.bounds.size.width * 0.95, height: 25.0))
                viewFieldBGColor = ((viewFieldBGColor.compare("#FFFFFF") == .OrderedSame) ? "#E7ECF2" : "#FFFFFF")
                refView.bgcolor = viewFieldBGColor
                refView.header = sdkey.localized()
                
                if let value = skipperDetails.valueForKey(sdkey) as? String{
                    refView.value = "\(value)"
                }else if let value = skipperDetails.valueForKey(sdkey) as? Double {
                    if value % 1 > 0 {
                        refView.value = "\(value)"
                    }else {
                        refView.value = "\(skipperDetails.valueForKey(sdkey) as!  Int)"
                    }
                }
                cell.viewDetailsContainer.addSubview(refView)
                // Separator
                let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top, width: refView.frame.width, height: 1.0))
                viewSeparator.backgroundColor = UIColor(rgba: "#CFD4D9")
                cell.viewDetailsContainer.addSubview(viewSeparator)
                top += 25.0
            }
        } else if indexPath.row == 2 {
            let craftDetails:NSDictionary = requestDetails?.objectForKey("CraftDetails") as! NSDictionary
            for cdkey in cdFields {
                let refView:RequestDetailsFieldView = RequestDetailsFieldView(frame: CGRect(x: 0, y: top, width: cell.bounds.size.width * 0.95, height: 25.0))
                viewFieldBGColor = ((viewFieldBGColor.compare("#FFFFFF") == .OrderedSame) ? "#E7ECF2" : "#FFFFFF")
                refView.bgcolor = viewFieldBGColor
                refView.header = cdkey.localized()
                
                if cdkey.compare("marineCraftPlateNumber") == .OrderedSame {
                    if (craftDetails.valueForKey("MarineCraftTypePrefix") as? String) != nil{
                        if (craftDetails.valueForKey("MarineCraftTypeNumber") as? String) != nil{
                            refView.value = "\(craftDetails.valueForKey("MarineCraftTypePrefix") as! String) \(craftDetails.valueForKey("MarineCraftTypeNumber") as! String)"
                        }
                    }
                }else if let value = craftDetails.valueForKey(cdkey) as? String{
                    refView.value = "\(value)"
                }else if let value = craftDetails.valueForKey(cdkey) as? Double {
                    if value % 1 > 0 {
                        refView.value = "\(value)"
                    }else {
                        refView.value = "\(craftDetails.valueForKey(cdkey) as!  Int)"
                    }
                }
                cell.viewDetailsContainer.addSubview(refView)
                // Separator
                let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top, width: refView.frame.width, height: 1.0))
                viewSeparator.backgroundColor = UIColor(rgba: "#CFD4D9")
                cell.viewDetailsContainer.addSubview(viewSeparator)
                top += 25.0
            }
        } else if indexPath.row == 3 {
            let eContactDetails:NSDictionary = requestDetails?.objectForKey("EmgContactDtails") as! NSDictionary
            for eckey in ecdFields {
                let refView:RequestDetailsFieldView = RequestDetailsFieldView(frame: CGRect(x: 0, y: top, width: cell.bounds.size.width * 0.95, height: 25.0))
                viewFieldBGColor = ((viewFieldBGColor.compare("#FFFFFF") == .OrderedSame) ? "#E7ECF2" : "#FFFFFF")
                refView.bgcolor = viewFieldBGColor
                refView.header = eckey.localized()
                
                if let value = eContactDetails.valueForKey(eckey) as? String{
                    refView.value = "\(value)"
                }
                
                if eckey.compare("PhoneNumber") == .OrderedSame {
                    refView.onBtnValueClicked = self.callNumber
                }
                
                cell.viewDetailsContainer.addSubview(refView)
                // Separator
                let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top, width: refView.frame.width, height: 1.0))
                viewSeparator.backgroundColor = UIColor(rgba: "#CFD4D9")
                cell.viewDetailsContainer.addSubview(viewSeparator)
                top += 25.0
            }
        }
        return cell as UITableViewCell
    }
    
    func callNumber(sender: AnyObject, value: String) -> Void {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(value)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                Utility.sharedInstance.showAlert(self, title: "call".localized(), message: "\(value)", onOkBtnTapped: { (sender) in
                    application.openURL(phoneCallURL);
                    }, isCancelHidden: false, onCancelBtnTapped: { (sender) in
                        
                })
            }else {
                Utility.sharedInstance.showAlert(self, title: "requestDetails".localized(), message: "invalidPhoneNumber".localized())
            }
        }else {
            Utility.sharedInstance.showAlert(self, title: "requestDetails".localized(), message: "invalidPhoneNumber".localized())
        }
    }
    
    /**
     Called on click of tableview row
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: indexpath information
     */
    /**
     Called on click of tableview row
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: indexpath information
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var previousIndexPath: NSIndexPath?
        if selectedCellIndexPath == indexPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            selectedCellIndexPath = nil
        }else {
            if (selectedCellIndexPath != nil) {
                previousIndexPath = selectedCellIndexPath!
            }
            selectedCellIndexPath = indexPath
        }
        tableView.beginUpdates()
        if (previousIndexPath != nil) {
            tableView.reloadRowsAtIndexPaths([previousIndexPath!, indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }else {
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
    }
}

