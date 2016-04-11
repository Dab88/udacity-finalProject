//
//  PhotosViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import CoreData

class PhotosViewController: UIViewController {
    
    var photoControl: PhotoControl?
    
    @IBOutlet weak var photoCollection: UICollectionView!
    
    @IBOutlet weak var noElementsView: UIView!
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    var persistenceContext: NSManagedObjectContext {
        return  PersistenceManager.instance.managedContext
    }
    
    
    lazy var fetchedController: NSFetchedResultsController = {
     
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.persistenceContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoControl = PhotoControl(currentViewController: self)
        photoControl?.delegate = self
        
        fetchedController.delegate = self
       
        do {
            try fetchedController.performFetch()
        } catch {
            NSLog("Fetch failed: \(error)")
        }
        
        
        print(self.fetchedController.sections![0].numberOfObjects == 0)
        noElementsView.hidden = (self.fetchedController.sections![0].numberOfObjects > 0)
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(4)
        
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func addNewPicture(sender: AnyObject) {
        photoControl?.showPhotoOptionsActionSheet()
    }
    
    
    func deletePhoto(indexPath:NSIndexPath) {
        
        let selectedPhoto = fetchedController.objectAtIndexPath(indexPath) as! Photo
        
        persistenceContext.deleteObject(selectedPhoto)
        
        PersistenceManager.instance.saveContext()
        
        noElementsView.hidden = (self.fetchedController.sections![0].numberOfObjects > 0)
        
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        photoCollection.performBatchUpdates(nil, completion: nil)
    }
}


extension PhotosViewController: PhotoControlProtocol{
    
    func addPhoto(image: UIImageView) {
        
        let photoName = "photo_\(NSDate().timeIntervalSince1970)"
        
        
        ImageLoader.instance.saveImageInDirectory(photoName, imagePhoto: image.image!)
        
        dispatch_async(dispatch_get_main_queue()) {
            PersistenceManager.instance.savePhoto(photoName)
            PersistenceManager.instance.saveContext()
            
            self.noElementsView.hidden = (self.fetchedController.sections![0].numberOfObjects > 0)
        }
        
        photoCollection.reloadData()
        
    }
}


extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if( self.fetchedController.sections != nil){
            return self.fetchedController.sections![section].numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionCell.identifier, forIndexPath: indexPath) as! PhotoCollectionCell
        
        let photo = fetchedController.objectAtIndexPath(indexPath) as! Photo
        
        //Set cell with values
        cell.setup(photo.url!)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        deletePhoto(indexPath)
    }
    
}


extension PhotosViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
        case .Update:
            updatedIndexPaths.append(indexPath!)
        case .Delete:
            deletedIndexPaths.append(indexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        photoCollection.performBatchUpdates({
            
            for indexPath in self.insertedIndexPaths {
                self.photoCollection.insertItemsAtIndexPaths([indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.photoCollection.deleteItemsAtIndexPaths([indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.photoCollection.reloadItemsAtIndexPaths([indexPath])
            }
            }, completion: nil)
    }
    
}