//
//  SearchVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/19/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit
import Dollar
import Cent

class SearchVC: ParentViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scbtnTrailing30: NSLayoutConstraint!
    @IBOutlet weak var scbtnTrailing42: NSLayoutConstraint!
    @IBOutlet weak var scbtnTrailing47: NSLayoutConstraint!
    
    
    var dropdownViewTag = 99
    private var lastContentOffset: CGFloat = 0
    var parameters: Dictionary<String, String> = [:]
    
    
    /// Constraints to be editted to adjust the UI
    // Constraint for the Depart Marina Label to Arrival Marina textfield
    @IBOutlet weak var dmToAmContraint: NSLayoutConstraint!
    @IBOutlet weak var dmToOAmConstraint: NSLayoutConstraint!
    // Constraint for the Submission Start Date & Time Label to Depart Marina Textfield
    @IBOutlet weak var sbsdtToDmConstraint: NSLayoutConstraint!
    @IBOutlet weak var sbsdtToODmConstraint: NSLayoutConstraint!
    
    // View Containers
    @IBOutlet weak var scrollviewContainer: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    
    // Form Fields
    @IBOutlet weak var txtMarinePlatePrefix: UITextField!
    @IBOutlet weak var txtMarinePlateNumber: UITextField!
    @IBOutlet weak var txtRequestStatus: UITextField!
    @IBOutlet weak var txtSailStartDateTime: UITextField!
    @IBOutlet weak var txtSailEndDateTime: UITextField!
    @IBOutlet weak var txtArrivalMarina: UITextField!
    @IBOutlet weak var txtOtherArrivalMarina: UITextField!
    @IBOutlet weak var txtDepartureMarina: UITextField!
    @IBOutlet weak var txtOtherDepartureMarina: UITextField!
    @IBOutlet weak var txtSubmissionStartDateTime: UITextField!
    @IBOutlet weak var txtSubmissionEndDateTime: UITextField!
    
    
    /**
     Called on view load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if Utility.DeviceType.IS_IPHONE_5 {
            scbtnTrailing30.priority = 101
        }else if Utility.DeviceType.IS_IPHONE_6 {
            scbtnTrailing42.priority = 102
        }else {
            scbtnTrailing47.priority = 101
        }
    }
    
    /**
     Called on memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Add Combo Box
     
     - parameter parentView: <#parentView description#>
     - parameter values:     <#values description#>
     - parameter key:        <#key description#>
     */
    func addComboBox(parentView:UITextField, values: NSArray, key: String) -> Void {
        self.view.viewWithTag(dropdownViewTag)?.removeFromSuperview()
        let comboboxView = AppComboBox(frame: CGRect(
            x: parentView.frame.origin.x,
            y: parentView.frame.origin.y + parentView.frame.height + 1.0,
            width: parentView.frame.width,
            height: 0.0))
        comboboxView.tag = dropdownViewTag
        comboboxView.values = values
        let val: String = parentView.text!
        if val.isEmpty {
            comboboxView.selectedValue = 0
        }else {
            comboboxView.selectedValue = parentView.tag
        }
        comboboxView.onBtnDone = { sender, index, value in
            if index > -1 {                
                switch key {
                case "MarineCraftTypePrefix":
                    self.parameters[key] = "\(NetworkManager.sharedInstance.marinaPrefixesList![index!])"
                    break
                case "RequestStatus":
                    if index == 0 {
                        self.parameters[key] = ""
                    }else {
                        self.parameters[key] = "\(NetworkManager.sharedInstance.statusList![index!])"
                    }
                    break
                case "ArrivalMarinaID":
                    self.parameters[key] = "\(NetworkManager.sharedInstance.marinaList![index!]["ID"] as! Int)"
                    if NetworkManager.sharedInstance.marinaList![index!]["ID"] as! Int == 17 {
                        self.dmToAmContraint.priority = 99
                        self.dmToOAmConstraint.priority = 100
                        UIView.animateWithDuration(0.25, animations: {
                            self.txtOtherArrivalMarina.hidden = false
                            self.txtOtherArrivalMarina.heightAnchor.constraintEqualToConstant(parentView.frame.height).priority = 100
                            self.viewContainer.layoutSubviews()
                        })
                    }else{
                        self.dmToAmContraint.priority = 100
                        self.dmToOAmConstraint.priority = 99
                        UIView.animateWithDuration(0.25, animations: {
                            self.txtOtherArrivalMarina.hidden = true
                            self.txtOtherArrivalMarina.heightAnchor.constraintEqualToConstant(0.0).priority = 100
                            self.viewContainer.layoutSubviews()
                        })
                    }
                    break
                case "DepartureMarinaID":
                    self.parameters[key] = "\(NetworkManager.sharedInstance.marinaList![index!]["ID"] as! Int)"
                    if NetworkManager.sharedInstance.marinaList![index!]["ID"] as! Int == 17 {
                        self.sbsdtToDmConstraint.priority = 99
                        self.sbsdtToODmConstraint.priority = 100
                        UIView.animateWithDuration(0.25, animations: {
                            self.txtOtherDepartureMarina.hidden = false
                            self.txtOtherDepartureMarina.heightAnchor.constraintEqualToConstant(parentView.frame.height).priority = 100
                            self.viewContainer.layoutSubviews()
                        })
                    }else{
                        self.sbsdtToDmConstraint.priority = 100
                        self.sbsdtToODmConstraint.priority = 99
                        UIView.animateWithDuration(0.25, animations: {
                            self.txtOtherDepartureMarina.hidden = true
                            self.txtOtherDepartureMarina.heightAnchor.constraintEqualToConstant(0.0).priority = 100
                            self.viewContainer.layoutSubviews()
                        })
                    }
                    
                    break
                default:
                    break
                }
            }else if (self.parameters[key]) != nil {
                self.parameters.removeValueForKey(key)
            }
            parentView.tag = index!
            parentView.text = value as? String
            self.animateViewAddRemove(comboboxView, isToAdd: false)
            
        }
        
        comboboxView.onBtnCancelled = { sender, index, value in
            parentView.tag = index!
            self.animateViewAddRemove(comboboxView, isToAdd: false)
        }
        self.animateViewAddRemove(comboboxView, isToAdd: true)
    }
    
    /**
     Add Date Picker
     
     - parameter parentView: <#parentView description#>
     - parameter key:        <#key description#>
     */
    func addDatePicker(parentView: UITextField, key: String) -> Void {
        self.view.viewWithTag(dropdownViewTag)?.removeFromSuperview()
        let datePickerView = AppDateComboBox(frame: CGRect(
            x: parentView.frame.origin.x,
            y: parentView.frame.origin.y + parentView.frame.height + 1.0,
            width: parentView.frame.width,
            height: 0.0))
        datePickerView.tag = dropdownViewTag
        datePickerView.dateString = (parentView.text)!
        
        datePickerView.onBtnDone = { sender, dateString in
            if let dstr:String = dateString as? String where dstr.isEmpty == false {
                self.parameters[key] = dateString as? String
            }else if (self.parameters[key]) != nil {
                self.parameters.removeValueForKey(key)
            }
            
            parentView.text = dateString as? String
            self.animateViewAddRemove(datePickerView, isToAdd: false)
        }
        datePickerView.onBtnCancelled = {sender, dateString in
            self.animateViewAddRemove(datePickerView, isToAdd: false)
        }
        self.animateViewAddRemove(datePickerView, isToAdd: true)
    }
    
    /**
     Add date time picker
     
     - parameter parentView: <#parentView description#>
     - parameter key:        <#key description#>
     */
    func addDateTimePicker(parentView: UITextField, key: String) -> Void {
        self.view.viewWithTag(dropdownViewTag)?.removeFromSuperview()
        let datePickerView = AppDateTimeComboBox(frame: CGRect(
            x: parentView.frame.origin.x,
            y: parentView.frame.origin.y + parentView.frame.height + 1.0,
            width: parentView.frame.width,
            height: 0.0))
        datePickerView.tag = dropdownViewTag
        datePickerView.dateString = (parentView.text)!
        
        datePickerView.onBtnDone = { sender, dateString in
            if let dstr:String = dateString as? String where dstr.isEmpty == false {
                self.parameters[key] = dateString as? String
            }else if (self.parameters[key]) != nil {
                self.parameters.removeValueForKey(key)
            }
            
            parentView.text = dateString as? String
            self.animateViewAddRemove(datePickerView, isToAdd: false)
        }
        datePickerView.onBtnCancelled = {sender, dateString in
            self.animateViewAddRemove(datePickerView, isToAdd: false)
        }
        
        self.animateViewAddRemove(datePickerView, isToAdd: true)
    }
    
    func animateViewAddRemove(view:UIView, isToAdd:Bool) -> Void {
        var frame:CGRect = view.frame
        frame.size.height = (isToAdd) ? 230.0 : 0.0
        
        if isToAdd {
            self.viewContainer.addSubview(view)
            self.viewContainer.bringSubviewToFront(view)
        }
        UIView.animateWithDuration(0.25, animations: {
            view.frame = frame
            view.layoutSubviews()
        }) { (isDone) in
            if !isToAdd {
                view.removeFromSuperview()
            }
        }
    }
    
    /**
     Called on re-click on search icon
     
     - parameter sender: sender description
     */
    @IBAction override func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    /**
     Called on click of search button
     
     - parameter sender: btnSearch
     */
    @IBAction func btnSearchClicked(sender: AnyObject) {
        print("Search Button Clicked")
        let plateNumber = txtMarinePlateNumber.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        if plateNumber!.isEmpty == false {
            parameters["MarineCraftTypeNumber"] = plateNumber
        }
        
        if txtSailStartDateTime.text!.isEmpty == false && txtSailEndDateTime.text!.isEmpty == false && Utility.sharedInstance.isEndGreaterThanStartDateTime(txtSailStartDateTime.text!, endDateTime: txtSailEndDateTime.text!)  == false{
            Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "invalidSailingEndDate".localized())
            return
        }
        if txtSubmissionStartDateTime.text!.isEmpty == false && txtSubmissionEndDateTime.text!.isEmpty == false && Utility.sharedInstance.isEndGreaterThanStartDate(txtSubmissionStartDateTime.text!, endDate: txtSubmissionEndDateTime.text!)  == false{
            Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "invalidSubmissionEndDate".localized())
            return
        }
        if parameters.count == 0 {
            Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "enterSearchField".localized())
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("SEARCHREQUEST", object: nil, userInfo: ["searchField" : self.parameters])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /**
     called on click of any of the textfield
     
     - parameter textField: textField description
     
     - returns: return value description
     */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == txtMarinePlatePrefix{
            if NetworkManager.sharedInstance.marinaPrefixesList?.count > 0 {
                self.addComboBox(self.txtMarinePlatePrefix, values: NetworkManager.sharedInstance.marinaPrefixesList! as NSArray, key: "MarineCraftTypePrefix")
            }else {
                NetworkManager.sharedInstance.callWSGetMarinaPrefixes(self.view, successCallback: { (result) in
                    self.addComboBox(self.txtMarinePlatePrefix, values: result as! NSArray, key: "MarineCraftTypePrefix")
                    }, errorCallback: { (result) in
                        Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "serviceError".localized())
                })
            }
        }else if textField == txtRequestStatus {
            if NetworkManager.sharedInstance.statusList?.count > 0 {
                self.addComboBox(self.txtRequestStatus, values: NetworkManager.sharedInstance.statusList! as NSArray, key: "RequestStatus")
            }else {
                NetworkManager.sharedInstance.callWSGetRequestStatus(self.view, successCallback: { (result) in
                    self.addComboBox(self.txtRequestStatus, values: result as! NSArray, key: "RequestStatus")
                    }, errorCallback: { (result) in
                        Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "serviceError".localized())
                })
            }
        } else if textField ==  txtSailStartDateTime {
            addDateTimePicker(self.txtSailStartDateTime, key: "SailingStartDate")
        } else if textField == txtSailEndDateTime {
            addDateTimePicker(self.txtSailEndDateTime, key: "SailingEndDate")
        } else if textField == txtArrivalMarina {
            if NetworkManager.sharedInstance.marinaList?.count > 0 {
                self.addComboBox(self.txtArrivalMarina, values: $.pluck(NetworkManager.sharedInstance.marinaList! as! [Dictionary<String, AnyObject>], value: ((AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame) ? "NameEn" : "NameAr" )) as NSArray, key: "ArrivalMarinaID")
            }else {
                NetworkManager.sharedInstance.callWSGetMarina(self.view, successCallback: { (result) in
                    self.addComboBox(self.txtArrivalMarina, values: $.pluck(result as! [Dictionary<String, AnyObject>], value:((AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame) ? "NameEn" : "NameAr" )) as NSArray, key: "ArrivalMarinaID")
                    }, errorCallback: { (result) in
                        Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "serviceError".localized())
                })
            }
        } else if textField == txtDepartureMarina {
            if NetworkManager.sharedInstance.marinaList?.count > 0 {
                self.addComboBox(self.txtDepartureMarina, values: $.pluck(NetworkManager.sharedInstance.marinaList! as! [Dictionary<String, AnyObject>], value: ((AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame) ? "NameEn" : "NameAr" )) as NSArray, key: "DepartureMarinaID")
            }else {
                NetworkManager.sharedInstance.callWSGetMarina(self.view, successCallback: { (result) in
                    self.addComboBox(self.txtDepartureMarina, values: $.pluck(result as! [Dictionary<String, AnyObject>], value:((AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame) ? "NameEn" : "NameAr" )) as NSArray, key: "DepartureMarinaID")
                    }, errorCallback: { (result) in
                        Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "serviceError".localized())
                })
            }
        } else if textField == txtSubmissionStartDateTime {
            addDatePicker(self.txtSubmissionStartDateTime, key: "CreatedStartDate")
        }else if textField == txtSubmissionEndDateTime {
            addDatePicker(self.txtSubmissionEndDateTime, key: "CreatedEndDate")
        }else {
            return true
        }
        return false
    }
    
    @IBAction func btnResetClicked(sender: AnyObject) {
        Utility.sharedInstance.showAlert(self, title: "search".localized(), message: "resetConfirm".localized(), onOkBtnTapped: { (sender) in
            self.txtMarinePlatePrefix.text = ""
            self.txtMarinePlateNumber.text = ""
            self.txtRequestStatus.text = ""
            self.txtSailStartDateTime.text = ""
            self.txtSailEndDateTime.text = ""
            self.txtArrivalMarina.text = ""
            self.txtOtherArrivalMarina.text = ""
            self.txtDepartureMarina.text = ""
            self.txtOtherDepartureMarina.text = ""
            self.txtSubmissionStartDateTime.text = ""
            self.txtSubmissionEndDateTime.text = ""
            self.parameters = [:]
            }, isCancelHidden: false)
    }
    
}
