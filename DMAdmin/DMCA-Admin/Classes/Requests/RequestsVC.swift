//
//  RequestsVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/16/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestsVC: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    let isEnglish:Bool = (AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame)
    
    var requests: NSMutableArray = []
    var parameters: Dictionary<String, AnyObject> = [:]
    var pageNumber: Int = 0
    var searchPageNumber:Int = 0
    var isSearchOn:Bool = false
    var selectedCellHeight: CGFloat = 50.0
    let unselectedCellHeight: CGFloat = 50.0
    
    var requestDetailsField:[String] = [
        "status",
        "startDateAndTime",
        "endDateAndTime",
        "marineCraftPlateNumber",
        "numberOfCrews",
        "numberOfPassengers",
        "emergencyContactDetails",
        "submissionDateAndTime",
        "submittedBy",
        "skipperDetails",
        "view"
    ]
    
    var updateStatusParameter: NSDictionary?
    
    var selectedCellIndexPath: NSIndexPath?
    
    @IBOutlet weak var tblviewRequests: UITableView!
    @IBOutlet weak var viewRemarks: UIView!
    @IBOutlet weak var txtviewRemark: UITextView!
    @IBOutlet weak var btnSendStatus: UIButton!
    @IBOutlet weak var btnHideRemarksView: UIButton!
    
    
    
    var refreshControl: UIRefreshControl! //93 163 228
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        self.title = "requests".localized()
        pageNumber = (requests.count > 0) ? 1 : 0
        
        self.tblviewRequests.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pullToRefresh".localized())
        refreshControl.addTarget(self, action: #selector(RequestsVC.loadRequests), forControlEvents: UIControlEvents.ValueChanged)
        self.tblviewRequests.addSubview(refreshControl)
        selectedCellHeight = (41.0 * CGFloat(requestDetailsField.count)) + 40.0 + 60.0
        if requests.count == 0 {
            searchRequests()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("View Will Disappear")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SEARCHREQUEST", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(searchWithSelectedFields), name: "SEARCHREQUEST", object: nil)
    }
    
    func loadRequests() -> Void {
        if isSearchOn {
            parameters["PageNumber"] = searchPageNumber
            NetworkManager.sharedInstance.callWSSearchRequest(parameters, containerView: self.view, successCallback: loadRequestsSuccessCallback, errorCallback: loadRequestsErrorCallback)
        }else {
            searchRequests()
        }
    }
    
    func enableTableview(isEnabled:Bool) -> Void {
        self.view.endEditing(isEnabled)
        self.viewRemarks.hidden = isEnabled
        self.tblviewRequests.userInteractionEnabled = isEnabled
    }
    
    @IBAction func showSearchPanel(sender: AnyObject) {
        let searchVC: SearchVC = Utility.sharedInstance.getViewControllerFromStoryboard("SearchVC") as! SearchVC
        searchVC.view.backgroundColor = UIColor.clearColor()
        searchVC.modalTransitionStyle = .CrossDissolve
        searchVC.modalPresentationStyle = .OverCurrentContext
        searchPageNumber = 0
        self.navigationController?.presentViewController(searchVC, animated: false, completion: nil)
    }
    
    @IBAction func homeBtnClicked(sender: AnyObject) {
        pageNumber = 0
        searchPageNumber = 0
        requests = []
        searchRequests()
    }
    
    
    @IBAction func btnSendStatusClicked(sender: AnyObject) {
        if updateStatusParameter != nil {
            let remark = txtviewRemark.text
            if remark.isEmpty{
                Utility.sharedInstance.showAlert(self, title: "requests".localized(), message: "emptyRemarks".localized())
            }else{
                NetworkManager.sharedInstance.callWSUpdateRequestStatus([
                    "ReferenceNumber" : updateStatusParameter!["ReferenceNumber"]!,
                    "RequestStatus" :  updateStatusParameter!["RequestStatus"]!,
                    "Reason" : remark
                    ], containerView: self.view, successCallback: requestStatusSuccessCallback, errorCallback: requestStatusErrorCallback)
            }
            
        }
    }
    
    @IBAction func btnHideRemarksViewClicked(sender: AnyObject) {
        enableTableview(true)
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
        return requests.count
    }
    
    /**
     Populate the row with proper information
     
     - parameter tableView: tblviewContacts
     - parameter indexPath: index information
     
     - returns: tableview cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "requestCell"
        let cell: RequestTVC = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RequestTVC
        cell.selectionStyle = .None
        
        let cellDictionary: NSDictionary = requests.objectAtIndex(indexPath.row) as! NSDictionary
        
        if let label = cell.lblRequestReference {
            let craftDetails: NSDictionary = cellDictionary.valueForKey("CraftDetails") as! NSDictionary
            label.text = "\(craftDetails.valueForKey("MarineCraftTypePrefix") as! String)\(craftDetails.valueForKey("MarineCraftTypeNumber") as! String)"
        }
        
        cell.viewDetailsContainer.hidden = !(selectedCellIndexPath == indexPath)
        if cell.viewDetailsContainer.hidden {
            cell.btnExpand.setImage(UIImage(named: "icn-dropdown-down"), forState: .Normal)
        }else {
            cell.btnExpand.setImage(UIImage(named: "icn-dropdown-up"), forState: .Normal)
        }
        
        var top:CGFloat = 0.0
        let status = cellDictionary["RequestStatusEn"] as! String
        for i in 0..<requestDetailsField.count {
            let requestFieldView:RequestFieldView = RequestFieldView(frame: CGRect(x: 0, y: top, width: (cell.bounds.size.width - 25.0), height: 40.0))
            requestFieldView.header = requestDetailsField[i].localized()
            requestFieldView.index = indexPath.row
            switch i {
            case 0:
                if status.isEmpty == false {
                    requestFieldView.value = "\(cellDictionary[(isEnglish) ? "RequestStatusEn" : "RequestStatusAr" ] as! String)"
                    requestFieldView.moreHidden = true
                }
                break
            case 1:
                if let startDate = cellDictionary["StartDateFormatted"] as? String {
                    requestFieldView.value = "\(startDate)"
                    requestFieldView.moreHidden = true
                }
                break
            case 2:
                if let endDate = cellDictionary["EndDateFormatted"] as? String {
                    requestFieldView.value = "\(endDate)"
                    requestFieldView.moreHidden = true
                }
                break
            case 3:
                if let prefix = cellDictionary["CraftDetails"]!["MarineCraftTypePrefix"] as? String {
                    if let number = requests[indexPath.row]["CraftDetails"]!!["MarineCraftTypeNumber"] as? String {
                        requestFieldView.value = "\(prefix) \(number)"
                        requestFieldView.fieldIndex = 2
                        requestFieldView.onMoreBtnTapped = self.btnMoreClicked
                    }
                }
                break
            case 4:
                if let numberOfCrews = cellDictionary["NumberOfCrews"] as? Int{
                    requestFieldView.value = "\(numberOfCrews)"
                    requestFieldView.moreHidden = true
                }
                break
            case 5:
                if let numberOfPassengers = cellDictionary["NumberOfPassengers"] as? Int {
                    requestFieldView.value = "\(numberOfPassengers)"
                    requestFieldView.moreHidden = true
                }
                break
            case 6:
                if let emergencyContactDetails = cellDictionary["EmgContactDtails"] as? NSDictionary {
                    if ((emergencyContactDetails["PhoneNumber"] as? String) != nil) {
                        requestFieldView.value = "\(emergencyContactDetails["PhoneNumber"] as! String)"
                        requestFieldView.fieldIndex = 3
                        requestFieldView.onMoreBtnTapped = self.btnMoreClicked
                    }
                    
                }
                break
            case 7:
                if let submissionDate = cellDictionary["CreatedDateFormatted"] as? String {
                    requestFieldView.value = "\(submissionDate)"
                    requestFieldView.moreHidden = true
                }
                break
            case 8:
                if let skipperName = cellDictionary["CreatedByStr"] as? String {
                    requestFieldView.value = "\(skipperName)"
                    requestFieldView.moreHidden = true
                }
                break
            case 9:
                if let skipperName = cellDictionary["SkipperDetails"]!["FullName"] as? String {
                    requestFieldView.value = "\(skipperName)"
                    requestFieldView.fieldIndex = 1
                    requestFieldView.onMoreBtnTapped = self.btnMoreClicked
                }
                break
            case 10:
                requestFieldView.value = "view".localized()
                requestFieldView.fieldIndex = 0
                requestFieldView.onMoreBtnTapped = self.btnMoreClicked
                break
            default:
                break
            }
            cell.viewDetailsContainer.addSubview(requestFieldView)
            let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top-1, width: cell.viewDetailsContainer.frame.width, height: 1.0))
            viewSeparator.backgroundColor = UIColor(rgba: "#DBDBDB")
            cell.viewDetailsContainer.addSubview(viewSeparator)
            
            
            top += 41.0
        }
        
        if (status.isEmpty == false) && (status.caseInsensitiveCompare("Pending") == .OrderedSame){
            // Last Separator
            let viewSeparator: UIView = UIView(frame: CGRect(x: 0, y: top-1, width: cell.viewDetailsContainer.frame.width, height: 1.0))
            viewSeparator.backgroundColor = UIColor(rgba: "#DBDBDB")
            cell.viewDetailsContainer.addSubview(viewSeparator)
            
            // Action View
            let requestActionsView:RequestActionsView = RequestActionsView(frame: CGRect(x: 0, y: top+1, width: (cell.bounds.size.width - 25.0), height: 45.0))
            requestActionsView.index = indexPath.row
            requestActionsView.onBtnApprovedTapped = updateRequestStatus
            requestActionsView.onBtnRejectedTapped = updateRequestStatus
            cell.viewDetailsContainer.addSubview(requestActionsView)
            
            cell.vdHeightConstraints.priority = 99
            cell.vdsHeightConstraints.priority = 100
            cell.viewDetailsContainer.tag = 1 // if status is pending
            
        }else {
            cell.vdHeightConstraints.priority = 100
            cell.vdsHeightConstraints.priority = 99
            
            cell.viewDetailsContainer.tag = 0 // if status is not pending
        }
        
        cell.contentView.layoutSubviews()
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellDictionary: NSDictionary = requests.objectAtIndex(indexPath.row) as! NSDictionary
        let status = cellDictionary["RequestStatusEn"] as! String
        if selectedCellIndexPath == indexPath {
            return ((status.isEmpty == false) && (status.caseInsensitiveCompare("Pending") == .OrderedSame)) ? selectedCellHeight : (selectedCellHeight - 55.0)
        }
        return unselectedCellHeight
    }
    
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
    
    /**
     More button is clicked
     
     - parameter sender:	view
     */
    func btnMoreClicked(sender: RequestFieldView, rowIndex:NSInteger) -> Void {
        let requestDetailsVC: RequestDetailsVC = Utility.sharedInstance.getViewControllerFromStoryboard("RequestDetailsVC") as! RequestDetailsVC
        requestDetailsVC.requestDetails = requests[rowIndex] as? NSMutableDictionary
        requestDetailsVC.initialSelectedIndex = sender.fieldIndex
        self.navigationController?.pushViewController(requestDetailsVC, animated: true)
    }
    
    /**
     Prepare for the segue operation
     
     - parameter segue:  segue from login view controller
     - parameter sender: login button
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if requests.count > 0 {
            if segue.identifier?.compare("requestdetails") == .OrderedSame {
                let indexPath : NSIndexPath = self.tblviewRequests.indexPathForCell(sender as! UITableViewCell)!
                let requestDetailsVC: RequestDetailsVC = segue.destinationViewController as! RequestDetailsVC
                requestDetailsVC.requestDetails = requests[indexPath.row] as? NSMutableDictionary
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    /**
     Callback for login user
     
     - parameter result: Response
     */
    func loadRequestsSuccessCallback(result: AnyObject) -> Void {
        if isSearchOn {
            searchPageNumber += 1
        }else {
            pageNumber += 1
        }
        self.refreshControl.endRefreshing()
        requests.addObjectsFromArray(result as! NSMutableArray as [AnyObject])
        self.tblviewRequests.reloadData()
    }
    
    /**
     Error Callback
     
     - parameter result: anyobject
     */
    func loadRequestsErrorCallback(result: AnyObject) -> Void {
        self.refreshControl.endRefreshing()
        if let msg = result.objectForKey("message") as? String {
            if (msg.compare("noRequestFound".localized()) == .OrderedSame) && ((pageNumber == 0 && isSearchOn == false) || (isSearchOn && searchPageNumber == 0)) {
                requests = []
                tblviewRequests.reloadData()
            }
        }
        Utility.sharedInstance.showAlert(self, title:"requests".localized(), message: (result.objectForKey("message") as? String)!)
    }
    
    /**
     Search Requests
     */
    func searchRequests() -> Void {
        isSearchOn = false
        NetworkManager.sharedInstance.callWSSearchRequest([
            "PageSize" : 20,
            "PageNumber" : pageNumber,
            "RequestStatus" : "Pending"
            ], containerView: self.view, successCallback: loadRequestsSuccessCallback, errorCallback: loadRequestsErrorCallback)
    }
    
    /**
     Callback for login user
     
     - parameter result: Response
     */
    func requestStatusSuccessCallback(result: AnyObject) -> Void {
        enableTableview(true)
        let response: NSMutableArray = result as! NSMutableArray
        Utility.sharedInstance.showAlert(self, title: "requests".localized(), message: response.objectAtIndex((AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame ? 0 : 1)) as! String) { (sender) in
            self.pageNumber = 0
            self.searchRequests()
        }
    }
    
    /**
     Error Callback
     
     - parameter result: anyobject
     */
    func requestStatusErrorCallback(result: AnyObject) -> Void {
        Utility.sharedInstance.showAlert(self, title:"requests".localized(), message: (result.objectForKey("message") as? String)!){ (sender) in
            self.enableTableview(true)
        }
    }
    
    func updateRequestStatus(sender:AnyObject, index:Int, status: String) -> Void {
        updateStatusParameter = [
            "ReferenceNumber" : requests[index]["refNumber"] as! String,
            "RequestStatus" : status
        ]
        enableTableview(false)
    }
    
    func searchWithSelectedFields(notification: NSNotification) -> Void {
        selectedCellIndexPath = nil
        requests = []
        isSearchOn = true
        parameters = (notification.userInfo?["searchField"])! as! Dictionary<String, AnyObject>
        parameters["PageNumber"] = searchPageNumber
        parameters["PageSize"] = 20
        NetworkManager.sharedInstance.callWSSearchRequest(parameters, containerView: self.view, successCallback: loadRequestsSuccessCallback, errorCallback: loadRequestsErrorCallback)
    }
    
}
