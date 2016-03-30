//
//  ShopViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

//TODO:
// ShowRequestMode
// Next search when show the last option
// Save Favorites
// Show product detail in webview
class ShopViewController: UIViewController {
    
    
    var currentPage:Int = 1
    var products:Array<Item> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(1)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        makeProductRequest()
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
        
        //Request first page
        //http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Dnd-FinalPro-PRD-b38c4f481-d931abea&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&keywords=babys&paginationInput.entriesPerPage=3
        
        
        //Request - Next page
        //http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=Dnd-FinalPro-PRD-b38c4f481-d931abea&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&keywords=babys&paginationInput.entriesPerPage=3&paginationInput.pageNumber=2
        
        //Para ver la segunda, tercera, etc pagina se usa el parametro paginationInput.pageNumber junto con el numero de elementos por pagina para que se pueda calcular. Por ejemplo:
        //paginationInput.entriesPerPage=3&paginationInput.pageNumber=2
        
        connection.get(APISettings.uriFind, parametersArray: params, serverTag: "PRODUCTS")
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


extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ProductCell = tableView.dequeueReusableCellWithIdentifier(ProductCell.identifier, forIndexPath: indexPath) as! ProductCell
        
        
        let product = products[indexPath.row]
        
        cell.setup(product)
        
        //Set tag
        cell.tag = indexPath.row
        
        return cell
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
            
            products = itemsResponse.item!
            
            tableView.reloadData()
            
        }
        
    }
    
    
    func didReceiveFail(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        
        print(errorObject)
    }
}