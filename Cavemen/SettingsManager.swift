//
//  SettingsManager.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation

class SettingsManager {
    
    class func saveEndPoint(endpoint: String) {
        NSUserDefaults.standardUserDefaults().setValue(NSString(string: endpoint), forKey: NSUserDefaultsValues.EndPoint.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getEndPoint() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(NSUserDefaultsValues.EndPoint.rawValue)
    }
    
    static var pushToken:String?
    
}
