//
//  FavoritesViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var products:Array<Product> = []
    var productSelected:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(3)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        products = PersistenceManager.instance.getFavorites()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews(){
        //Remove padding in tableview cells
        if (tableView!.respondsToSelector(Selector("setSeparatorInset:"))){
            tableView!.separatorInset = UIEdgeInsetsZero
        }
        
        if (tableView!.respondsToSelector(Selector("setLayoutMargins:"))){
            tableView!.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "ProductDetail" {
            
            let vc = segue.destinationViewController as! ProductDetailViewController
            
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            vc.productURL = productSelected
            
        }
    }
    
}



extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: FavoriteCell = tableView.dequeueReusableCellWithIdentifier(FavoriteCell.identifier, forIndexPath: indexPath) as! FavoriteCell
        
        let product = products[indexPath.row]
        
        cell.setup(product)
        
        //Set tag
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Remove left padding in cells
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))){
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = products[indexPath.row]
        
        productSelected = product.viewUrl!
        
        //Show next view
        performSegueWithIdentifier("ProductDetail", sender: self)
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
}
