//
//  Event.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import Foundation
import CoreData


class Event: NSManagedObject {
    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var identifier: String?
}
