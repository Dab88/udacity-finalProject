//
//  EventViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UIViewController {
    
    //Color Rosa D19FCA
    //Color Gris C9C9C9
    //BACKGROUND FFEFC3
    //Purpura A03AE8
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startDate: NSDate = NSDate()
    var eventId: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if eventId != ""{
            loadEvent()
        }
        
        datePicker.setDate(startDate, animated: true)
    }
    
    func loadEvent(){
        
        let store = EKEventStore()
        
        store.requestAccessToEntityType(.Event) {(granted, error) in
            
            if let event = store.eventWithIdentifier(self.eventId){
                self.eventName.text = event.title
                self.startDate = event.startDate
                self.datePicker.setDate(self.startDate, animated: true)
            }else{
                
                //TODO: El evento ha sido eliminado del calendario, cree otro
                
                PersistenceManager.instance.deleteEvent(self.eventId)
            }
            
            
        }
        
    }
    //MARK: IBActions
    @IBAction func birthdayChange(sender: UIDatePicker) {
        startDate =  sender.date
    }
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addEvent(sender: AnyObject) {
        
        let store = EKEventStore()
        
        if let event = store.eventWithIdentifier(self.eventId){
            
            store.requestAccessToEntityType(.Event) {(granted, error) in
                
                guard granted else { return }
                
                event.title = self.eventName.text!
                event.startDate = self.startDate
                
                //1 hour long meeting
                event.endDate = event.startDate.dateByAddingTimeInterval(60*60)
                
                event.calendar = store.defaultCalendarForNewEvents
                
                do {
                    try store.saveEvent(event, span: .ThisEvent, commit: true)
                    
                    //TODO: Mostrar mensaje de exito
                    
                    PersistenceManager.instance.updateEvent(event.startDate, name: event.title, identifier: event.eventIdentifier)
                    
                    
                    //Ir a la pantalla anterior
                    self.goBack(sender)
                    
                } catch {
                    // Display error to user
                }
            }
        }else{
            
            store.requestAccessToEntityType(.Event) {(granted, error) in
                
                guard granted else { return }
                
                let event = EKEvent(eventStore: store)
                
                event.title = self.eventName.text!
                event.startDate = self.startDate
                
                //1 hour long meeting
                event.endDate = event.startDate.dateByAddingTimeInterval(60*60)
                
                event.calendar = store.defaultCalendarForNewEvents
                
                do {
                    try store.saveEvent(event, span: .ThisEvent, commit: true)
                    self.eventId = event.eventIdentifier
                    
                    PersistenceManager.instance.saveEvent(event.startDate, name: event.title, identifier: event.eventIdentifier)
                    
                    //TODO: Mostrar mensaje de exito
                    
                    //Ir a la pantalla anterior
                    self.goBack(sender)
                    
                } catch {
                    // Display error to user
                }
            }
        }
    }
    
    @IBAction func deleteEvent(sender: AnyObject) {
        
        PersistenceManager.instance.deleteEvent(self.eventId)
        
        deleteEvent()
        
    }
    
    func deleteEvent(){
        
        let store = EKEventStore()
        
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.eventWithIdentifier(self.eventId)
            if eventToRemove != nil {
                do {
                    try store.removeEvent(eventToRemove!, span: .ThisEvent, commit: true)
                } catch {
                    // Display error to user
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
