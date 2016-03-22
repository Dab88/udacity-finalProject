//
//  PhotoControl.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

protocol PhotoControlProtocol : class {
    func addPhoto(image: UIImageView)
}

class PhotoControl: NSObject {
    
    let currentViewController: UIViewController?
    var delegate:PhotoControlProtocol?
    
    
    init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
    
    
    func showPhotoOptionsActionSheet(){
        
        //Show Alert
        let alertController = UIAlertController(title: "Select image source", message: "", preferredStyle: .ActionSheet)
        
        let capturePhotoAction = UIAlertAction(title: Messages.bCamera, style: UIAlertActionStyle.Default) {
            (action) in self.shootPhoto()
        }
        
        let photoLibraryAction = UIAlertAction(title: Messages.bLibrary, style: UIAlertActionStyle.Default) {
            (action) in self.getPhotoFromLibrary()
        }
        
        let cancelAction = UIAlertAction(title: Messages.bCancel, style: UIAlertActionStyle.Cancel, handler:  nil)
        
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            alertController.addAction(capturePhotoAction)
        }
        alertController.addAction(photoLibraryAction)
        
        
        alertController.addAction(cancelAction)
        
        currentViewController!.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func shootPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .Camera
        pickerController.modalPresentationStyle = .FullScreen
        pickerController.cameraCaptureMode = .Photo
        currentViewController!.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func getPhotoFromLibrary(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        currentViewController!.presentViewController(pickerController, animated: true, completion: nil)
    }
    
}


extension PhotoControl: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.currentViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            let imageView = UIImageView(image: chosenImage)
            
            self.currentViewController!.dismissViewControllerAnimated(true, completion: nil)
            
            delegate?.addPhoto(imageView)
        }
        
    }
}

