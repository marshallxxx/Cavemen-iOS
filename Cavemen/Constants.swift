//
//  Constants.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation
import UIKit

enum TableViewCells: String {
    case ProjectCell = "ProjectTableViewCell"
    case JobCell = "JobTableViewCell"
}

enum Segues: String {
    case ToJobs = "toJobsSegue"
    case ToScanner = "toQRScanner"
    case ToJobDetails = "toJobDetails"
}

enum NSUserDefaultsValues: String {
    case EndPoint = "endppppp"
}

enum EndpointsPath: String {
    case Projects = "projects"
    case Jobs = "jobs"
    case Job = "job"
}

enum Fonts {
    case Font1
    
    func getFont() -> UIFont? {
        
        return nil
    }
    
}

let healthURL = "http://rice-group.googlecode.com/svn/com.fh/target/jenkins-for-test/images/32x32/"

enum Colors {
    case Color1
    
    func getColor() -> UIColor {
        
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}