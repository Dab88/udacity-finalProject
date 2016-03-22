//
//  Product.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import Foundation
import CoreData


class Product: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var imageUrl: String?
    @NSManaged var favorite: NSNumber?

}
