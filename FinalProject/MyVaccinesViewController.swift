//
//  MyVaccinesViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class MyVaccinesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var savedEventId: String = ""
    var events = [Event]()
    var selectedEventID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(0)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedEventID = ""
        events = PersistenceManager.instance.getEvents()
        tableView.reloadData()
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let destination = segue.destinationViewController as! EventViewController
        destination.eventId = selectedEventID
        
    }
    
    
}


extension MyVaccinesViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(EventCell.identifier, forIndexPath: indexPath) as! EventCell
        
        let event = events[indexPath.row]
        
        cell.setup(event)
        
        //Set tag
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedEventID = events[indexPath.row].identifier!
        performSegueWithIdentifier("editEvent", sender: self)
    }
    
}


