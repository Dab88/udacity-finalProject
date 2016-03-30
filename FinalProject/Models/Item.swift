//
//  Item.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/29/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit


class Item: NSObject {
    
    var title:String?
    var galleryURL:String?
    var viewItemURL:String?
    var sellingStatus:NSDictionary?
    var price:String?
    var currency:String?
    
    //No used
    var primaryCategory:[AnyObject]?
    var globalId:[String]?
    var itemId:String?
    
    init(response: NSDictionary){
        
        super.init()
        
        if let id = response["itemId"] as? [String]{
            itemId = id[0]
        }
        
        if let titleArray = response["title"] as? [String]{
            title = titleArray[0]
        }
        
        if let gallery = response["galleryURL"] as? [String]{
            galleryURL = gallery[0]
        }
        
        if let itemURL = response["viewItemURL"] as? [String]{
            viewItemURL = itemURL[0]
        }
        
        if let sellingStatus = response["sellingStatus"] as? [NSDictionary]{
            
            self.sellingStatus = sellingStatus[0]
            
            let currentPrice =  self.sellingStatus!["currentPrice"] as! [NSDictionary]
       
            self.currency = (currentPrice[0] as! [String:String])["@currencyId"]
            self.price = (currentPrice[0] as! [String:String])["__value__"]
        }
    }
}

/*{
 "itemId": [
 "161813532396"
 ],
 "title": [
 "Converse Low Top All Star Ox Baby Boy Girl Toddler Infant Pink Shoes Size 2-10"
 ],
 "globalId": [
 "EBAY-US"
 ],
 "primaryCategory": [
 {
 "categoryId": [
 "147285"
 ],
 "categoryName": [
 "Baby Shoes"
 ]
 }
 ],
 "galleryURL": [
 "http://thumbs1.ebaystatic.com/pict/1618135323964040_1.jpg"
 ],
 "viewItemURL": [
 "http://www.ebay.com/itm/Converse-Low-Top-All-Star-Ox-Baby-Boy-Girl-Toddler-Infant-Pink-Shoes-Size-2-10-/161813532396?var=460785985772"
 ],
 "sellingStatus": [
 {
 "currentPrice": [
 {
 "@currencyId": "USD",
 "__value__": "29.95"
 }
 ],
 "convertedCurrentPrice": [
 {
 "@currencyId": "USD",
 "__value__": "29.95"
 }
 ],
 "sellingState": [
 "Active"
 ],
 "timeLeft": [
 "P0DT21H20M54S"
 ]
 }
 ]
 }*/