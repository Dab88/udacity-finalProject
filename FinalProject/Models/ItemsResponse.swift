//
//  ItemsResponse.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/29/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class ItemsResponse: NSObject {
    
    var sellingStatus:[AnyObject]?
    var count:String?
    var item:[Item]?
    
    init(response: NSDictionary){
        
        var itemsTemp:Array<Item> = []
        
        if let items = response["item"] as? [AnyObject]{
        
            for object in items{
                
                if object is NSDictionary{
                    
                    let program = Item(response: object as! NSDictionary)
                    
                    print(program)
                    
                    itemsTemp.append(program)
                    
                }
            }
        }
        
        item = itemsTemp
        
    }
    

}
