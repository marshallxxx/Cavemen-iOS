//
//  JobTableViewCell.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit

enum JobStatus {
    case Success
    case NotRun
    case Fail
    
    func getColor() -> UIColor {
        switch self {
        case Success:
            return UIColor.blueColor()
        case NotRun:
            return UIColor.grayColor()
        case Fail:
            return UIColor.redColor()
        }
    }
    
}

class JobTableViewCell: UITableViewCell {

    var jobName:String?
    var jobStatus: JobStatus?
    
//    @IBOutlet weak var statusView: UIView!
//    @IBOutlet weak var jobNameLabel: UILabel!
    
    func updateCellDetails() {
        
        textLabel?.text = jobName
        
//        jobNameLabel?.text = jobName
//        
//        if let status = jobStatus {
//            statusView?.backgroundColor = status.getColor()
//        }
    }
    
}
