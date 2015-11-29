//
//  JobsListViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit
import CoreData
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

//class JobDescription {
//    var actions: [String]?
//    var description: String?
//    var name: String?
//    var buildable: Bool?
//    var builds: [String]?
//    var firstBuild: String?
////    "healthReport": []
//    var inQueue: Bool?
////    "keepDependencies": false,
//    var lastBuild: String?
//    var lastCompletedBuild: String?
//    var lastFailedBuild: String?
//    var lastStableBuild: String?
//    var lastSuccessfulBuild: String?
//    var lastUnstableBuild: String?
//    var lastUnsuccessfulBuild: String?
//    var nextBuildNumber: Int?
////    "property": [],
////    "queueItem": null,
////    "concurrentBuild": false,
////    "downstreamProjects": [],
////    "scm": {},
////    "upstreamProjects": []
//    
//    
//    init(initialValue:JSON) {
//        description = initialValue["description"].string
//        name = initialValue["name"].string
//        buildable = initialValue["buildable"].bool
//        builds = initialValue["builds"]
//        firstBuild = initialValue["firstBuild"].string
//        inQueue = initialValue["inQueue"].bool
//        lastBuild = initialValue["lastBuild"].string
//        lastCompletedBuild = initialValue["lastCompletedBuild"].string
//        lastFailedBuild = initialValue["lastFailedBuild"].string
//        lastStableBuild = initialValue["lastStableBuild"].string
//        lastSuccessfulBuild = initialValue["lastSuccessfulBuild"].string
//        lastUnstableBuild = initialValue["lastUnstableBuild"].string
//        lastUnsuccessfulBuild = initialValue["lastUnsuccessfulBuild"].string
//        nextBuildNumber = initialValue["nextBuildNumber"].int
//    }
//}

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

class JobsListViewController: UITableViewController, JobsViewControllerProtocol {
    
    var project: Project?
    var jobModels:[JobModel]?
    
    var jobSelected: String?
    var jobConfig:JobConfig?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setting name
        
        guard let proj = project else {
            return;
        }
        
        title = "\(proj.name!) Jobs"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Registe TableViewCell
        tableView.registerClass(JobTableViewCell.self, forCellReuseIdentifier: TableViewCells.JobCell.rawValue)
        
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobModels?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let job = jobModels![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCells.JobCell.rawValue, forIndexPath: indexPath) as! JobTableViewCell
        
        cell.jobName = job.jobName
        cell.jobStatus = job.jobStatus
        cell.updateCellDetails()
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier ?? "" {
        case Segues.ToJobDetails.rawValue:

            if let jobDetailsVC = segue.destinationViewController as? JobDetailsViewControllerProtocol {
                jobDetailsVC.jobName = jobSelected ?? ""
                jobDetailsVC.jobConfig = jobConfig
            }
            
        default:
            break
        }
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        jobSelected = jobModels?[indexPath.row].jobName
        
        let loadingVC = LoadingViewController.getInstanceOfLoadingViewController()
        self.presentViewController(loadingVC, animated: false, completion: nil)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager!.getJobConfig(jobSelected!) { (jsonResponse) -> () in
            loadingVC.dismissViewControllerAnimated(false, completion: nil)
            
            if jsonResponse != nil {
                self.jobConfig = JobConfig(data: jsonResponse!)
                self.performSegueWithIdentifier(Segues.ToJobDetails.rawValue, sender: self)
            }
        }
        
        
    }
    
}
