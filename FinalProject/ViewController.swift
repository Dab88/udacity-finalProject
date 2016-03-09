//
//  ViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    
    var savedEventId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func addEvent(sender: AnyObject) {
        
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let event = EKEvent(eventStore: store)
            event.title = "Event Title"
            event.startDate = NSDate() //today
            event.endDate = event.startDate.dateByAddingTimeInterval(60*60) //1 hour long meeting
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.saveEvent(event, span: .ThisEvent, commit: true)
                self.savedEventId = event.eventIdentifier //save event id to access this particular event later
            } catch {
                // Display error to user
            }
        }
    }
}

