//
//  NetworkManager.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 4/20/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit
import Alamofire
import Dollar
import Cent

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    
    var usersList: NSArray?
    var statusList: NSArray?
    var marinaPrefixesList: NSArray?
    var marinaList: NSArray?
    
    // Base URL
    let baseUrl = "http://demoserver.tacme.net:3030/DMCATacsoftH3/Services/UserAcountRestService.svc/"
    
    /**
     Get the USERID
     
     - returns: userID
     */
    func getUserID() -> String {
        let userinfo = AppDelegate.getAppDelegate().defaults.objectForKey("userinfo") as! NSDictionary
        if let userID = userinfo.valueForKey("usertoken") as? String {
            return userID
        }
        return ""
    }
    
    
    /**
     Login user
     
     - parameter email:        email
     - parameter password:     password
     */
    func callWSLogin(parameters:[String: AnyObject], containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
        Alamofire.request(.GET, "\(baseUrl)UserLogin", parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                AppActivityIndicator.sharedInstance.hideLoader(containerView)
                switch response.result {
                case .Success(let JSON):
                    let response = JSON as! NSMutableArray
                    if (response.count) == 0 {
                        errorCallback(result: ["message" : "noRequestFound".localized()])
                    }else{
                        if(response.count == 1 && (response[0]["refNumber"] as! String).compare("Invalid Login") == .OrderedSame) {
                            errorCallback(result: ["message" : "invalidCredentials".localized()])
                        }else{
                            successCallback(result: response)
                        }
                    }
                case .Failure(let error):
                    errorCallback(result: ["message" : error.localizedDescription])
                }
        }
    }
    
    
    /**
     Forgot Password
     
     - parameter email:        email
     */
    func callWSForgotPassword(parameters:[String: AnyObject], containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
        Alamofire.request(.GET, "\(baseUrl)ForgetPassword", parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                AppActivityIndicator.sharedInstance.hideLoader(containerView)
                switch response.result {
                case .Success(let JSON):
                    let response = JSON as! NSMutableArray
                    if (response.count) == 0 {
                        errorCallback(result: ["message" : "serviceError".localized()])
                    }else{
                        successCallback(result: response)
                    }
                case .Failure(let error):
                    errorCallback(result: ["message" : error.localizedDescription])
                }
        }
    }
    
    /**
     Search Request user
     
     - parameter MarineCraftTypePrefix: MarineCraftTypePrefix(optional)
     - parameter MarineCraftTypeNumber: MarineCraftTypeNumber(optional)
     - parameter ReferenceNumber: ReferenceNumber(optional)
     - parameter RequestStatus:     RequestStatus(optional)
     - parameter SailingStartDate:     SailingStartDate(optional)
     - parameter SailingEndDate:     SailingEndDate(optional)
     - parameter ArrivalMarinaID:     MarineCraftTypePrefix(optional)
     - parameter DepartureMarinaID:     MarineCraftTypeNumber(optional)
     - parameter CreatedStartDate:     CreatedStartDate(optional)
     - parameter CreatedEndDate: CreatedEndDate(optional)
     - parameter PageSize:     PageSize
     - parameter PageNumber:     PageNumber
     */
    func callWSSearchRequest(parameters:[String: AnyObject], containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        print(parameters)
        AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
        Alamofire.request(.GET, "\(baseUrl)SearchRequest", parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                AppActivityIndicator.sharedInstance.hideLoader(containerView)
                switch response.result {
                case .Success(let JSON):
                    if let response = JSON as? NSArray {
                        if (response.count) == 0 {
                            if (parameters["PageNumber"] as! Int > 0){
                                errorCallback(result: ["message" : "noMoreRequestFound".localized()])
                            }else {
                                errorCallback(result: ["message" : "noRequestFound".localized()])
                            }
                        }else{
                            if(response.count == 1 && (response[0]["refNumber"] as! String).compare("Invalid Login") == .OrderedSame) {
                                errorCallback(result: ["message" : "invalidCredentials".localized()])
                            }else{
                                successCallback(result: response.mutableCopy())
                            }
                        }
                    }else{
                        print(response)
                    }
                    
                case .Failure(let error):
                    errorCallback(result: ["message" : error.localizedDescription])
                }
        }
    }
    
    /**
     Update request status
     
     - parameter ReferenceNumber: ReferenceNumber
     - parameter RequestStatus: RequestStatus
     - parameter Reason: Reason
     */
    func callWSUpdateRequestStatus(parameters:[String: AnyObject], containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        print(parameters)
        AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
        Alamofire.request(.GET, "\(baseUrl)UpdateRequestStatus", parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                AppActivityIndicator.sharedInstance.hideLoader(containerView)
                switch response.result {
                case .Success(let JSON):
                    if let response = JSON as? NSArray {
                        if (response.count) == 0 {
                            errorCallback(result: ["message" : "serviceError".localized()])
                        }else{
                            successCallback(result: response.mutableCopy())
                        }
                    }else{
                        print(response)
                    }
                    
                case .Failure(let error):
                    errorCallback(result: ["message" : error.localizedDescription])
                }
        }
    }
    
    /**
     Search Request user
     */
    func callWSGetAllUsers(containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        if self.usersList?.count > 0 {
            successCallback(result: (self.usersList?.mutableCopy())!)
        }else {
            AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
            Alamofire.request(.GET, "\(baseUrl)GetAllUsers", parameters: [:])
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    AppActivityIndicator.sharedInstance.hideLoader(containerView)
                    switch response.result {
                    case .Success(let JSON):
                        if let response = JSON as? NSArray {
                            if (response.count) == 0 {
                                errorCallback(result: ["message" : "noUsersFound".localized()])
                            }else{
                                //                            if(response.count == 1 && (response[0]["refNumber"] as! String).compare("Invalid Login") == .OrderedSame) {
                                //                                errorCallback(result: ["message" : "invalidCredentials".localized()])
                                //                            }else{
                                
                                self.usersList = $.map(response as! [Dictionary<String, AnyObject>], transform: { (obj) -> Dictionary<String, AnyObject> in
                                    return ["ID": obj["ID"] as! Int,"FullName": "\(obj["FirstName"] as! String)\(obj["LastName"] as! String)"]
                                })
                                successCallback(result: (self.usersList?.mutableCopy())!)
                                //                            }
                            }
                        }else{
                            print(response)
                        }
                        
                    case .Failure(let error):
                        errorCallback(result: ["message" : error.localizedDescription])
                    }
            }
        }
    }
    
    /**
     Search Request user
     */
    func callWSGetRequestStatus(containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        if self.statusList?.count > 0 {
            successCallback(result: (self.statusList?.mutableCopy())!)
        }else {
            AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
            Alamofire.request(.GET, "\(baseUrl)GetAllStatus", parameters: [:])
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    AppActivityIndicator.sharedInstance.hideLoader(containerView)
                    switch response.result {
                    case .Success(let JSON):
                        if let response = (JSON as? NSArray)?.mutableCopy() {
                            if (response.count) == 0 {
                                errorCallback(result: ["message" : "noStatusFound".localized()])
                            }else{
                                response.insertObject("all".localized(), atIndex: 0)
                                print(response)
                                self.statusList = NSArray(array: response as! [AnyObject])
                                successCallback(result: (self.statusList?.mutableCopy())!)
                            }
                        }else{
                            print(response)
                        }
                        
                    case .Failure(let error):
                        errorCallback(result: ["message" : error.localizedDescription])
                    }
            }
        }
    }
    
    func callWSGetMarinaPrefixes(containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        if self.marinaPrefixesList?.count > 0 {
            successCallback(result: (self.marinaPrefixesList?.mutableCopy())!)
        }else {
            AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
            Alamofire.request(.GET, "\(baseUrl)GetAllPlatePrefixes", parameters: [:])
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    AppActivityIndicator.sharedInstance.hideLoader(containerView)
                    switch response.result {
                    case .Success(let JSON):
                        if let response = JSON as? NSArray {
                            print(response)
                            if (response.count) == 0 {
                                errorCallback(result: ["message" : "noStatusFound".localized()])
                            }else{
                                self.marinaPrefixesList = response
                                successCallback(result: (self.marinaPrefixesList?.mutableCopy())!)
                            }
                        }else{
                            print(response)
                        }
                        
                    case .Failure(let error):
                        errorCallback(result: ["message" : error.localizedDescription])
                    }
            }
        }
    }
    
    /**
     Search Request user
     */
    func callWSGetMarina(containerView: UIView, successCallback: (result:AnyObject) -> Void, errorCallback: (result:AnyObject) -> Void){
        if self.marinaList?.count > 0 {
            successCallback(result: (self.marinaPrefixesList?.mutableCopy())!)
        }else {
            AppActivityIndicator.sharedInstance.showLoader(containerView, message: "loading".localized())
            Alamofire.request(.GET, "\(baseUrl)GetAllMarinas", parameters: ["PageSize": 20, "PageNumber" : 0])
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    AppActivityIndicator.sharedInstance.hideLoader(containerView)
                    switch response.result {
                    case .Success(let JSON):
                        if let response = JSON as? NSArray {
                            if (response.count) == 0 {
                                errorCallback(result: ["message" : "noMarinaPrefixFound".localized()])
                            }else{
                                self.marinaList = $.map(response as! [Dictionary<String, AnyObject>], transform: { (obj) -> Dictionary<String, AnyObject> in
                                    return ["ID": obj["ID"] as! Int,"NameAr": "\(obj["NameAr"] as! String)", "NameEn" : "\(obj["NameEn"] as! String)"]
                                })
                                successCallback(result: (self.marinaList?.mutableCopy())!)
                            }
                        }else{
                            print(response)
                        }
                        
                    case .Failure(let error):
                        errorCallback(result: ["message" : error.localizedDescription])
                    }
            }
        }
    }
    
    
}
