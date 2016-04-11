//
//  Photo.swift
//  
//
//  Created by Daniela Velasquez on 4/8/16.
//
//

import Foundation
import CoreData


class Photo: NSManagedObject {
    
    @NSManaged var url: String?
    
    convenience init(url: String, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    
        self.url = url
    }
    
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        ImageLoader.instance.deleteImage(url!)
    }


    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
