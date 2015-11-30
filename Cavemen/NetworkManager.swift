//
//  NetworkManager.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkManager {
    
    var accessEndpoint:String
    
    init (endpoint:String) {
        accessEndpoint = endpoint
    }
    
    func getEnpointFor(path:EndpointsPath) -> String {
        return "\(accessEndpoint)\(path.rawValue)"
    }
    
    // MARK: - Requests
    
    func getJobsForProject(project: String, callback: ([JSON]?) -> ())  {
        
        let request = NSURLRequest(URL: NSURL(string: "\(getEnpointFor(.Projects))/\(project)")!)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    
                    if let jobs = json["jobs"].array {
                        callback(jobs)
                        return
                    }
                }
                
                callback(nil)
            })
           
        }
        
        dataTask.resume()
        
    }
    
    func getJobInfo(job: String, callback: (JSON?) -> ()) {
        let request = NSURLRequest(URL: NSURL(string: "\(getEnpointFor(.Jobs))/\(job.stringByReplacingOccurrencesOfString(" ", withString: "%20"))")!)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    callback(json)
                }
                
                callback(nil)
            })
            
        }.resume()
    }
    
    func postJobConfig(postData: Dictionary<String, AnyObject>, job: String, callback: (JSON?) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(getEnpointFor(.Jobs))/\(job.stringByReplacingOccurrencesOfString(" ", withString: "%20"))/config")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postData, options: NSJSONWritingOptions.PrettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    callback(JSON(data: data!))
                    return
                }
                
                callback(nil)
            })
        }.resume()
    }
    
    func getJobConfig(job: String, callback: (JSON?) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(getEnpointFor(.Jobs))/\(job.stringByReplacingOccurrencesOfString(" ", withString: "%20"))/config?device=\(SettingsManager.pushToken ?? "")")!)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    let response = JSON(data: data!)
                    callback(response)
                }
                
                callback(nil)
            })
        }.resume()
    }
    
    func postJobCommand(job: String, callback: (NSString?) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(getEnpointFor(.Job))/\(job.stringByReplacingOccurrencesOfString(" ", withString: "%20"))/start")!)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    return
                }
                
                callback(nil)
            });
            }.resume()
    }
    
}
