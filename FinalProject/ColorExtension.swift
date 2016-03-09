//
//  ColorExtension.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit


struct MSColor{
    
    static let fideDarkBlue:String = "005B83" //rgb 0 91 131 - deepSeaBlue
    static let fideBackgroundGray:String = "F0F0F0" //rgb 240 240 240 //white
    static let fideWhiteGray:String = "FAFAFA" //250 250 250 white90
    static let fideSilver:String = "C8C7CC" //rgb 200 199 204 - Silver
    
    static let fideSilverGray:String = "C8C7CC" //rgb 200 199 204
    static let fideNavBarTint:String = "115C84" //rgb 17 92 132
    
    static let fideVeryWeak:String = "F60095" //rgb 240 0 149
    static let fideWeak:String = "F82E09"     //rgb 248 46 9
    static let fideModerate:String = "F6BE41" //rgb 246 190 65
    static let fideStrong:String = "AFD15B"   //rgb 145 209 91
    static let fideVeryStrong:String = "00688C" //rgb 0 104 140

    static let rose:String = "D19FCA"
    static let gray:String = "C9C9C9"
    static let backgroundColor:String = "FFEFC3"
    static let purple:String = "A03AE8"
    static let turquoise:String = "32B8C7"


}

extension UIColor {
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString(hex:String, alpha: CGFloat = 1.0) -> UIColor {
        
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
        var gString = cString.substringFromIndex(cString.startIndex.advancedBy(2))
        gString = gString.substringToIndex(gString.startIndex.advancedBy(2))
        var bString = cString.substringFromIndex(cString.startIndex.advancedBy(4))
        bString = bString.substringToIndex(bString.startIndex.advancedBy(2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    
    // Creates a RGB Color from a Hex string.
    func rgbWithHexString (hex:String) -> Array<CGFloat> {
        
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        
        //Gray
        if (cString.characters.count != 6) {
            
            let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
            var r:CUnsignedInt = 0
            NSScanner(string: rString).scanHexInt(&r)
            
            let red = CGFloat(r) / 255.0
            let rgbColor = [red,red,red]
            
            return rgbColor
        }
        
        let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
        var gString = cString.substringFromIndex(cString.startIndex.advancedBy(2))
        gString = gString.substringToIndex(gString.startIndex.advancedBy(2))
        var bString = cString.substringFromIndex(cString.startIndex.advancedBy(4))
        bString = bString.substringToIndex(bString.startIndex.advancedBy(2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        let rgbColor = [CGFloat(r) / 255.0, CGFloat(g) / 255.0, CGFloat(b) / 255.0]
        
        return rgbColor
    }
    
    
    
    /**
     * Create a UIColor from a hex int number.
     * @param: The hexa number using the prefix "0x".
     * * Example: red is FF0000 -> The param is 0xFF0000
     * @return: A UIColor
     */
    func colorWithRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    /**
     * Create hexString from a UIColor.
     * @param: UIColor
     * @return: String with color in Hex format
     */
    func hexStringWithColor (color:UIColor) -> String {
        
        let rgb = color.CGColor
        let numComponents:Int = CGColorGetNumberOfComponents(rgb)
        let components = CGColorGetComponents(rgb)
        
        let red:CGFloat   = components[0]
        let green:CGFloat = components[1]
        let blue:CGFloat  = components[2]
        
        var hexColor = ""
        
        if(numComponents != 4){
            let grayString = NSString(format:"%2X", Int(red*255))  as String
            hexColor = "\(grayString)\(grayString)\(grayString)"
        }
        else{
            
            let redString   = NSString(format:"%2X", Int(red*255))   as String
            let greenString = NSString(format:"%2X", Int(green*255)) as String
            let blueString  = NSString(format:"%2X", Int(blue*255))  as String
            
            hexColor = "\(redString)\(greenString)\(blueString)"
            
        }
        
        //Replace whitespace by 0
        hexColor = hexColor.stringByReplacingOccurrencesOfString(" ", withString: "0", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return hexColor
    }
    
    
}