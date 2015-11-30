//
//  Models.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/30/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation
import SwiftyJSON

class JobModel {
    var jobName:String?
    var jobStatus: JobStatus
    
    init (name: String?, status:String? ) {
        jobName = name
        
        switch status ?? "" {
        case "blue":
            jobStatus = .Success
        case "red":
            jobStatus = .Fail
        default:
            jobStatus = .NotRun
        }
    }
}

class JobCommands {
    var success: Bool
    var warning: Bool
    var fail: Bool
    
    init (s:Bool, w:Bool, f:Bool) {
        success = s
        warning = w
        fail = f
    }
    
}

class JobConfig {
    
    var device:String?
    var jobName: String?
    var notifyOk: Bool
    var notifyWarning: Bool
    var notifyFail: Bool
    
    init (data:JSON) {
        device = data["device"].string
        jobName = data["jobName"].string
        notifyOk = data["notifyOk"].bool ?? false
        notifyWarning = data["notifyWarning"].bool ?? false
        notifyFail = data["notifyFail"].bool ?? false
    }
    
    func serialize() -> Dictionary<String, AnyObject> {
        return [ "device" : device ?? "",
            "jobName" : jobName ?? "",
            "notifyOk" : NSNumber(bool: notifyOk),
            "notifyWarning" : NSNumber(bool: notifyWarning),
            "notifyFail" : NSNumber(bool: notifyFail)]
    }
}