//
//  ImageLoader.swift
//  VirtualTourist
//
//  Created by Daniela Velasquez on 2/27/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit


class ImageLoader {
    
    class var instance : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        
        return Static.instance
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    func imageFromUrl(url: NSURL, completionHandler:(image: UIImage?, url: String) -> ()){
        
        let path = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let fileName = url.lastPathComponent
        let urlPath = path.URLByAppendingPathComponent(fileName!)
        
        if NSFileManager.defaultManager().fileExistsAtPath(urlPath.path!) {
            
            let data = NSData(contentsOfURL: urlPath)
           
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: url.absoluteString)
                })
            }
            
            return
        }
        
        
        getDataFromUrl(url) { (data, response, error)  in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                guard let data = data where error == nil else { return }
                
                if let image = UIImage(data: data){
                    
                    //Save in Documents Directory
                   NSFileManager.defaultManager().createFileAtPath(urlPath.path!, contents: data, attributes: nil)
                    //print("Save success : - \(success)")
                    
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: url.absoluteString)
                    })
                }
                return
            }
        }
    }
    
    
    func deleteImage(imageName: String) {
        
        let path = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let imagePath = path.URLByAppendingPathComponent(imageName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(imagePath)
            } catch {
                print("Remove image error: \(imageName)")
            }
        }
    }

    
    func imageCamera(filePath: String, completionHandler:(image: UIImage?, url: String) -> ()){
        
        let path = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let fileName = filePath
        let urlPath = path.URLByAppendingPathComponent(fileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(urlPath.path!) {
            
            let data = NSData(contentsOfURL: urlPath)
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: fileName)
                })
            }
            
            return
        }else{
        
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: nil, url: fileName)
                })
                
                return
            }
        }
        
    }
    
    func saveImageInDirectory(filePath: String, imagePhoto: UIImage) -> Bool{
    
        let path = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let fileName = filePath
        let urlPath = path.URLByAppendingPathComponent(fileName)
        let imageData: NSData = UIImagePNGRepresentation(imagePhoto)!
       
        //Save in Documents Directory
        let success = NSFileManager.defaultManager().createFileAtPath(urlPath.path!, contents: imageData, attributes: nil)
        
        print("Save success : - \(success) \(urlPath.path)")
        
        return success
    }

    
}