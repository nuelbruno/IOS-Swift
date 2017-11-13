//
//  Utility.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 4/21/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import Foundation
import UIKit


class Utility: NSObject {
    
    // sharedInstance
    static let sharedInstance = Utility()
    
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    func showAlert (vc: UIViewController, title: String, message: String, onOkBtnTapped:((sender:AnyObject)-> Void) = {_ in }, isCancelHidden:Bool = true, onCancelBtnTapped:((sender:AnyObject)-> Void) = {_ in }){
        let aaVC = AppAlertViewController(nibName: "AppAlertViewController", bundle: nil)
        
        aaVC.alertTitle = title
        aaVC.alertMessage = message
        aaVC.isCancelHidden = isCancelHidden
        aaVC.onOkBtnTapped = onOkBtnTapped
        aaVC.onCancelBtnTapped = onCancelBtnTapped
        aaVC.modalTransitionStyle = .CrossDissolve
        aaVC.definesPresentationContext = true
        aaVC.modalPresentationStyle = .OverCurrentContext

        // Present View "Modally"
        vc.presentViewController(aaVC, animated: true, completion: nil)
    }
    
    func getViewControllerFromStoryboard(viewController: String) -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: AppDelegate.getAppDelegate().getAppLanguage().compare("en") == .OrderedSame ? "Main" : "Main_ar",bundle: nil)
        return mainStoryboard.instantiateViewControllerWithIdentifier(viewController)
    }
    
    func getDuration(startDate: String, endDate: String) -> String {
        if startDate.isEmpty || endDate.isEmpty {
            return ""
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm a"
        let sd: NSDate = dateFormatter.dateFromString(startDate)!
        let ed: NSDate = dateFormatter.dateFromString(endDate)!
        
        let dayHourMinuteSecond: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: sd, toDate: ed, options: [])
        
        var duration = ""
        if difference.year > 0 {
            duration = "\(difference.year)yr "
        }
        if difference.month > 0 {
            duration = "\(duration)\(difference.month)mon "
        }
        if difference.day > 0 {
            duration = "\(duration)\(difference.day)day "
        }
        if difference.hour > 0 {
            duration = "\(duration)\(difference.hour)hr "
        }
        if difference.minute > 0 {
            duration = "\(duration)\(difference.minute)min "
        }
        if difference.second > 0 {
            duration = "\(duration)\(difference.second)sec "
        }
        return duration
    }
    
    func isEndGreaterThanStartDateTime(startDateTime:String, endDateTime: String) -> Bool {
        let dateTimeFormatter = NSDateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
        let lhd = dateTimeFormatter.dateFromString(startDateTime)
        let rhd = dateTimeFormatter.dateFromString(endDateTime)
        
        if lhd != nil && rhd != nil {
            return (lhd?.compare(rhd!) == .OrderedAscending ? true : false)
        }
        return false
    }
    
    func isEndGreaterThanStartDate(startDate:String, endDate: String) -> Bool {
        let dateTimeFormatter = NSDateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd"
        let lhd = dateTimeFormatter.dateFromString(startDate)
        let rhd = dateTimeFormatter.dateFromString(endDate)
        
        if lhd != nil && rhd != nil {
            return (lhd?.compare(rhd!) == .OrderedAscending ? true : false)
        }
        return false
    }
}
