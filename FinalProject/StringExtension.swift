//
//  StringExtension.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/22/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//


import UIKit

extension String {
    
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    func digitsOnly() -> String{
        let stringArray = self.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        
        return newString
    }

}