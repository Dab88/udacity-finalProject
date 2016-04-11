//
//  Messages.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import Foundation


import UIKit

//Documentation
//http://developer.ebay.com/devzone/finding/concepts/MakingACall.html

struct APISettings{
    
    /*
     Production Endpoint:
     http://svcs.ebay.com/services/search/FindingService/v1
     
     Sandbox Endpoint:
     http://svcs.sandbox.ebay.com/services/search/FindingService/v1
     */
    
    //Production
    static let baseUrl:String = "http://svcs.ebay.com"
    //Sandbox Endpoint:
    //static let baseUrl:String = "http://svcs.sandbox.ebay.com"
    
    static let APP_ID = "Dnd-FinalPro-PRD-b38c4f481-d931abea"
    
    static let uriFind:String     = baseUrl + "/services/search/FindingService/v1"
    
    
    
}


struct Messages {
    
    static let titleMyProfile =  ""
    static let titleAlert = "Sorry!"
    static let titleNetworkProblems = "Network Problems"
    
    static let mNoInternetConnection =  "No internet access"
    static let mNoPins = "Sorry you don't have pins"
    
    static let bOk = "OK"
    static let bDismiss = "Dismiss"
    static let bCancel = "Cancel"
    static let bYes = "Yes"
    static let bNo  = "No"
    static let bCamera  = "Camera"
    static let bLibrary  = "Photo Library"
    
    
}



struct Support {
    
    
    static func showGeneralAlert(title:String, message:String, currentVC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: Messages.bOk, style: .Default, handler: nil)
        alert.addAction(dismissAction)
        currentVC.presentViewController(alert, animated: true, completion: nil)
    }
    
}