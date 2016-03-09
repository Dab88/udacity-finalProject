//
//  HomeTabBarViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//


import UIKit

class HomeTabBarViewController: UITabBarController{
    
    let selectedColor = UIColor().colorWithHexString(MSColor.rose)
    let navBarColor = UIColor().colorWithHexString(MSColor.rose)
    let navBarTint = UIColor.darkGrayColor()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set general background
        setBackground()
        
        //Set items selected color
        setItemsColors()
    
        //Set Baby when selected view
        selectedIndex = 2
       
        addNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    func setBackground(){
        self.view.backgroundColor = .clearColor()
        /*let backgroundImage = UIImageView(image:  UIImage(named: "background2"))
        self.view.insertSubview(backgroundImage, atIndex: 0)*/
    }
    
    
    func setItemsColors(){
        
        if let font = UIFont(name: "Optima-Bold", size: 16) {
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor, NSFontAttributeName: font], forState:.Selected)
        }
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.selectedImage {
                item.selectedImage = image.imageWithColor(selectedColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func addNavigationBar(){
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = navBarColor
        navigationBar.tintColor = selectedColor
        
        //Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "PREGNANTS"
        
        //Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        
        //Set Optima font in NavigationBar
        if let font = UIFont(name: "Optima-Bold", size: 18) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font,NSForegroundColorAttributeName: navBarTint]
        }
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     /*   if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as! NavigationViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.transitionOperator //OJO
            toViewController.delegate = self
        }*/
    }
    
    
}

