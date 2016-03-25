//
//  Baby.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/25/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

enum GENDER: String {
    case boy  = "boy"
    case girl = "girl"
}

class Baby: NSObject, NSCoding {

    var name: String = ""
    var momName: String = ""
    var dadName: String = ""
    var bornDate: String = ""
    var gender: GENDER = GENDER.boy
    
    
    required override init(){
        super.init()
    }
    
    init(response: NSDictionary) {
        
        super.init()
        
        if let name = response.objectForKey("name") as? String{
            self.name = name
        }
        
        if let momName = response.objectForKey("momName") as? String{
            self.momName = momName
        }
        
        if let dadName = response.objectForKey("dadName") as? String{
            self.dadName = dadName
        }
        
        if let bornDate = response.objectForKey("bornDate") as? String{
            self.bornDate = bornDate
        }
        
        if let gender = response.objectForKey("gender") as? String{
            
            if(gender == "boy"){
                self.gender = GENDER.boy
            }else{
                self.gender = GENDER.girl
            }
        }
       	
    }

    
    // MARK: MSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        let userMirror = Mirror(reflecting: self)
        for (_, att) in userMirror.children.enumerate(){
            aCoder.encodeObject("\(att.value)", forKey: att.label!)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let params:NSMutableDictionary = NSMutableDictionary()
        let userMirror = Mirror(reflecting: Baby())
        
        for att in userMirror.children.enumerate(){
            if let val =  aDecoder.decodeObjectForKey(att.element.label!) as? String{
                params[att.element.label!]  = val
            }
        }
        
        let parameters:NSDictionary = params
        
        self.init(response: parameters as! [String : AnyObject])
    }
    
}
