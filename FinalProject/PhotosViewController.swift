//
//  PhotosViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    var photoControl: PhotoControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoControl = PhotoControl(currentViewController: self)
        photoControl?.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(4)
        
        super.viewWillAppear(animated)
        
    }
    

    @IBAction func addNewPicture(sender: AnyObject) {
        photoControl?.showPhotoOptionsActionSheet()
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


extension PhotosViewController: PhotoControlProtocol{
    
    func addPhoto(image: UIImageView) {
        
        //TODO: Add new image in array
        //TODO: Save in coredata
       
    }
}