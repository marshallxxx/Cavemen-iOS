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
