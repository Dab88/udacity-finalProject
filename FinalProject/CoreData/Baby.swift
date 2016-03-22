//
//  Baby.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import Foundation
import CoreData


class Baby: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var momName: String?
    @NSManaged var dadName: String?
    @NSManaged var bornDate: NSDate?
    @NSManaged var gender: NSNumber?
}
