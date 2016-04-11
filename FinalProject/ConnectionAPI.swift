//
//  ConnectionAPI.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/29/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import Foundation
import UIKit

public enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}


/**
 * APIConnectionProtocol
 */
@objc protocol ConnectionAPIProtocol : NSObjectProtocol {
    /**
     * @author: Daniela Velasquez
     * Delegate Funtion - ConnectionAPIProtocol
     * Is called when the request success
     */
    func  didReceiveSuccess(results results: AnyObject, path: String, serverTag: String)
    
    /**
     * @author: Daniela Velasquez
     * Delegate Funtion - ConnectionAPIProtocol
     * Is called when the request failed
     */
    func didReceiveFail(error error: NSError, errorObject: AnyObject, path: String, serverTag: String)
}

class ConnectionAPI: NSObject {
    
    var delegate: ConnectionAPIProtocol?
    var session = NSURLSession.sharedSession()
    
    
    class var instance: ConnectionAPI {
        
        struct Static {
            static var instance: ConnectionAPI?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = ConnectionAPI()
        }
        return Static.instance!
    }
    
    
    override init() {
        self.delegate = nil
    }
    
    init(delegate: ConnectionAPIProtocol) {
        self.delegate = delegate
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func get(path: String, parametersArray: [String : AnyObject]?, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.GET, path: path, parametersArray: parametersArray, serverTag: serverTag)
    }
    
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func post(path: String, parametersArray: [String : AnyObject]? = nil, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.POST, path: path, parametersArray: parametersArray, serverTag: serverTag)
        
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func put(path: String, parametersArray: [String : AnyObject]?, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.PUT, path: path, parametersArray: parametersArray, serverTag: serverTag)
        
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func delete(path: String, parametersArray: [String : AnyObject]? = nil, serverTag: String, parseRequest:Bool = false) {
        self.request(.DELETE, path: path, parametersArray: parametersArray, serverTag: serverTag)
        
    }
    
    func request(method: Method, path: String, parametersArray: [String : AnyObject]?, serverTag: String) {
        
        print("\n\(serverTag) - \(method.rawValue)\nURL:  \(path)\n")
        if let param = parametersArray{
            print("PARAMETER REQUEST: \n \(param.description)\n")
        }
        
        var urlString = path
        let request = NSMutableURLRequest()
        
        if method != .GET {
            
            if let param = parametersArray{
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(param, options: [])
                } catch _ as NSError {
                    request.HTTPBody = nil
                }
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        }else {
            if let param = parametersArray{
                urlString += "?"
                for (key, value) in param {
                    let valueEncoded = value.description!.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                    urlString += key + "=" + (valueEncoded!.stringByReplacingOccurrencesOfString("+", withString: "%2B")) + "&"
                }
            }
        }
        
        request.HTTPMethod = method.rawValue
        request.URL = NSURL(string: urlString)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            var errorObject:NSError?
            
            if(response != nil){
                
                print("Response code: \((response as! NSHTTPURLResponse).statusCode)")
                
                if(self.errorResponse((response as! NSHTTPURLResponse).statusCode)){
                    
                    var errorMessage = "Request Error"
                    
                    if(data != nil){
                        let validData = data
                        
                        let jsonResponse = self.getJSON(validData!, response: (response as! NSHTTPURLResponse))
                        
                        if let json = jsonResponse as? NSDictionary{
                            if(json["error"] != nil){
                                errorMessage = json["error"] as! String
                            }
                        }
                    }
                    
                    errorObject = NSError(domain: errorMessage, code: (response as! NSHTTPURLResponse).statusCode, userInfo: nil)
                    
                }else{
                    
                    if(data != nil){
                        var result: AnyObject?
                        
                        let validData = data
                        
                        print("Body: \(NSString(data: validData!, encoding: NSUTF8StringEncoding))")
                        
                        let jsonResponse = self.getJSON(validData!, response: (response as! NSHTTPURLResponse))
                        
                        if let parseJSON = jsonResponse as? NSDictionary{
                            result = parseJSON
                        }
                        
                        if let result = result{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.delegate?.didReceiveSuccess(results: result, path: path, serverTag: serverTag)
                                return
                            })
                            
                        
                        }
                        
                    }else if (error != nil) {
                        errorObject = error
                    }
                }
            }
            
            if let errorObject = errorObject{
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.didReceiveFail(error: errorObject, errorObject: errorObject, path: path, serverTag: serverTag)
                })
               
            }
            
        })
        
        task.resume()
    }
    
    
    func getJSON(validData: NSData, response: NSHTTPURLResponse) -> AnyObject?{
        
        do{
            if let parseJSON = try NSJSONSerialization.JSONObjectWithData(validData, options:NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                return parseJSON
            }
        }catch{
            return NSError(domain: "Malformed JSON", code: response.statusCode, userInfo: nil)
        }
        
        return  NSError(domain: "Malformed JSON", code: response.statusCode, userInfo: nil)
    }
    
    func errorResponse(statusCode: Int) -> Bool {
        if statusCode < 200 || statusCode >= 300 {
            return true
        }
        
        return false
    }
    
}
