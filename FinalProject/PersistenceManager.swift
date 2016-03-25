//
//  PersistenceManager.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/22/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class PersistenceManager: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let babyKey = "babyInfo"
    var baby:Baby?
    
    class var instance: PersistenceManager {
        
        struct Static {
            static var instance: PersistenceManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PersistenceManager()
        }
        
        return Static.instance!
    }
    
    required override init(){
        baby = Baby()
    }
    
    
    func saveBaby(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(baby!)
        
        defaults.setObject(encodedObject, forKey: babyKey)
        defaults.synchronize()
        
        loadBaby()
        
    }
    
    func loadBaby(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let usertemp = defaults.objectForKey(babyKey) {
            if let babyObject = NSKeyedUnarchiver.unarchiveObjectWithData(usertemp as! NSData) as? Baby{
                baby = babyObject
            }
        }
        
    }
    
    func getEvents() -> [Event]{
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [Event]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return [Event]()
        }
        
    }
    
    
    //MARK: Save Methods
    
    func saveEvent(date: NSDate, name: String, identifier: String){
        
        let entity =  NSEntityDescription.entityForName("Event", inManagedObjectContext:managedContext)
        
        let pin = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        pin.setValue(identifier, forKey: "identifier")
        pin.setValue(date, forKey: "date")
        pin.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func updateEvent(date: NSDate, name: String, identifier: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            let event = results[0] as! Event
            
            event.setValue(identifier, forKey: "identifier")
            event.setValue(date, forKey: "date")
            event.setValue(name, forKey: "name")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteEvent(identifier: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            let event = results[0] as! Event
            
            managedContext.deleteObject(event)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /*
     func savePhoto(pin: Pin, imagePath: String, name: String){
     let photo = Photo(name: name , imageUrl: imagePath, context: managedContext)
     photo.pin = pin
     }
     */
    
    //MARK:
    func saveContext() {
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                print("saveContext() error: \(error)")
                abort()
            }
        }
        
    }
}
