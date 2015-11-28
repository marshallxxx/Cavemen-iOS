//
//  JobsListViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit
import CoreData

class JobsListViewController: UITableViewController, JobsViewControllerProtocol {

    var project: Project?
    var jobs: [Job]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setting name
        
        guard let proj = project else {
            return;
        }
        
        title = proj.name
        jobs = Array<Job>(proj.jobs!)
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
        return project?.jobs?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let job = jobs?[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCells.ProjectCell.rawValue, forIndexPath: indexPath) as! JobTableViewCell
        
        cell.jobName = job?.name
        cell.updateCellDetails()
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}
