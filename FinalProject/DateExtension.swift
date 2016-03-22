//
//  MSDateExtension.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/22/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//


import UIKit

extension NSDate {
    //Format:
    func defaultFormat() -> String{
        return  "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }
    
    func defaultOnlyDateFormat() -> String{
        return  "yyyy-MM-dd"
    }
    
    func dateFromString(date: String, format: String) -> NSDate {
      
        let formatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        formatter.locale = locale
        formatter.dateFormat = format
        
        var dateWithFormat = formatter.dateFromString(date)
        
        if(dateWithFormat == nil){
            formatter.dateFormat = defaultFormat()
            dateWithFormat = formatter.dateFromString(date)
            
            if(dateWithFormat == nil){
                dateWithFormat = NSDate()
            }
        }
        
        return dateWithFormat!
    }
    

    func stringFromDateInLocalFormat() -> String{
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyy h:mm a"
        formatter.AMSymbol = "AM"
        formatter.PMSymbol = "PM"
        
        return formatter.stringFromDate(self)
        
    }

    
    
}