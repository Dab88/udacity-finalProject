//
//  ShopViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    
    var currentPage:Int = 1
    var products:Array<Item> = []
    var productSelected:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeProductRequest()
        showRequestMode(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(1)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    func makeProductRequest(){
        
        let connection = ConnectionAPI(delegate: self)
        
        var params: [String: String] = [ : ]
        params["OPERATION-NAME"] = "findItemsByKeywords"
        params["SERVICE-VERSION"] = "1.0.0"
        params["SECURITY-APPNAME"] = APISettings.APP_ID
        params["GLOBAL-ID"] = "EBAY-US"
        params["RESPONSE-DATA-FORMAT"] = "JSON"
        params["keywords"] = "babys"
        params["paginationInput.entriesPerPage"] = "10"
        params["paginationInput.pageNumber"] = "\(currentPage)"
        
        connection.get(APISettings.uriFind, parametersArray: params, serverTag: "PRODUCTS")
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "ProductDetail" {
            
            let vc = segue.destinationViewController as! ProductDetailViewController
            
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            vc.productURL = productSelected
            
        }
    }
    
    
    func showRequestMode(show: Bool){
        
        if(show){
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        overlay.hidden = !show
        tableView.hidden = show
    }
}


extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row < products.count - 1){
            let cell: ProductCell = tableView.dequeueReusableCellWithIdentifier(ProductCell.identifier, forIndexPath: indexPath) as! ProductCell
            
            let product = products[indexPath.row]
            cell.setup(product)
            
            //Set tag
            cell.tag = indexPath.row
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LastProductCell", forIndexPath: indexPath) as! ProductCell
        
        
        //Set tag
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == products.count - 1){
            currentPage = currentPage + 1
            makeProductRequest()
        }
        
        //Remove left padding in cells
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))){
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < products.count - 1){
            
            let product = products[indexPath.row]
            
            productSelected = product.viewItemURL!
            
            //Show next view
            performSegueWithIdentifier("ProductDetail", sender: self)
            
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.row < products.count - 1){
            return 100.0
        }
        
        return 70.0
        
    }
    
}


extension ShopViewController: ConnectionAPIProtocol{
    
    func  didReceiveSuccess(results results: AnyObject, path: String, serverTag: String){
        
        print(results)
        
        var jsonResult = results as! Dictionary<String, AnyObject>
        
        let resultsArray = jsonResult["findItemsByKeywordsResponse"] as! [AnyObject]
        
        for object in resultsArray{
            let searchResult = object["searchResult"] as! [NSDictionary]
            let itemsResponse = ItemsResponse(response: searchResult[0])
            
            products.appendContentsOf(itemsResponse.item!)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.showRequestMode(false)
            self.tableView.reloadData()
        })
        
        
    }
    
    
    func didReceiveFail(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        
        showRequestMode(false)
        print(errorObject)
    }
}