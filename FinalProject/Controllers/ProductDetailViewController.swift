//
//  ProductDetailViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 4/7/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController{
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overlay: UIView!
   
    var productURL:String = ""
    var successViewController:UIViewController?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.userInteractionEnabled = true
        
        if(available()){
            loadRequest()
        }
    }
    
    //MARK IBAction Methods
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Other Methods
    
    /**
     * Validate Internet access
     */
    func available() -> Bool{
        if(Reachability.isConnectedToNetwork()){
            return true
        }else{
            Support.showGeneralAlert("", message: Messages.mNoInternetConnection, currentVC: self)
        }
        
        return false
    }
    
    func loadRequest(){
        
        showRequestMode(true)
        
        print(successViewController?.classForCoder)
        
        let requestURL = NSURL(string:productURL)
        
        let request = NSURLRequest(URL: requestURL!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20)
        
        webView.loadRequest(request)
    }
    
    
    
    func showRequestMode(show: Bool){
        
        if(show){
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        overlay.hidden = !show
    }
}


extension ProductDetailViewController: UIWebViewDelegate{
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return true
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView){
        
        showRequestMode(false)
        webView.userInteractionEnabled = true
       
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        webView.userInteractionEnabled = true
        
        showRequestMode(false)
        
        Support.showGeneralAlert("", message: Messages.mNoInternetConnection, currentVC: self)
        
    }
}
