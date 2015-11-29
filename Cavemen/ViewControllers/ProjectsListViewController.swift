//
//  ProjectsListViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ProjectsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ScanViewControllerProtocol {
    
    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var projectListTableView: UITableView!
    
    var projectsFetchController: NSFetchedResultsController!
    
    var projectSelected: Project?
    var jobModels: [JobModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Localization
        noProjectsLabel.text = "No projects".localized
        
        // Initialize Fetched Controller
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let request = NSFetchRequest(entityName: DBEntities.Projects.getEntityName())
        request.sortDescriptors = [ sortDescriptor ]
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        projectsFetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil);
        
        try! projectsFetchController.performFetch()
        
        projectsFetchController.delegate = self
        
        checkIfProjectsAvailable()
        
        projectListTableView.registerClass(ProjectTableViewCell.self, forCellReuseIdentifier: TableViewCells.ProjectCell.rawValue)
        projectListTableView.dataSource = self
        projectListTableView.delegate = self
        
        title = "Projects"
        
    }
    
    func checkIfProjectsAvailable() {
        // Show/Hide projectListTableView/noProjectsLabel
        let entriesAvailable = projectsFetchController.sections![0].numberOfObjects > 0
        projectListTableView.hidden = !entriesAvailable
        noProjectsLabel.hidden = entriesAvailable
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return projectsFetchController.sections!.count ?? 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsFetchController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let project = projectsFetchController.objectAtIndexPath(indexPath) as! Project
        let cell = projectListTableView.dequeueReusableCellWithIdentifier(TableViewCells.ProjectCell.rawValue, forIndexPath: indexPath) as! ProjectTableViewCell
        
        cell.projectName = project.name
        cell.updateCellDetails()
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func parseJobs(jobs:[JSON]?) -> [JobModel] {
        var models = [JobModel]()
        for jobJson in jobs! {
            let job = JobModel(name: jobJson["name"].string, status: jobJson["color"].string)
            models.append(job)
        }
        return models
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        projectSelected = projectsFetchController.objectAtIndexPath(indexPath) as? Project
        
        let loadingVC = LoadingViewController.getInstanceOfLoadingViewController()
        self.presentViewController(loadingVC, animated: false, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager!.getJobsForProject(projectSelected!.name!) { (jobsList) -> () in
            
            loadingVC.dismissViewControllerAnimated(false, completion: nil)
            
            if jobsList != nil {
                self.jobModels = self.parseJobs(jobsList)
                self.performSegueWithIdentifier(Segues.ToJobs.rawValue, sender: self)
            }
            
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        projectListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        projectListTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch (type) {
        case .Insert:
            projectListTableView.insertRowsAtIndexPaths([ newIndexPath! ], withRowAnimation: .Fade)
        case .Delete:
            projectListTableView.deleteRowsAtIndexPaths([ indexPath! ], withRowAnimation: .Fade)
        case .Update:
            let cell = projectListTableView.cellForRowAtIndexPath(indexPath!) as! ProjectTableViewCell
            let project = projectsFetchController.objectAtIndexPath(indexPath!) as! Project
            cell.projectName = project.name
            cell.updateCellDetails()
        case .Move:
            projectListTableView.deleteRowsAtIndexPaths([ indexPath! ], withRowAnimation: .Fade)
            projectListTableView.insertRowsAtIndexPaths([ newIndexPath! ], withRowAnimation: .Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let project = projectsFetchController.objectAtIndexPath(indexPath) as! Project
            (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataManager.removeProject(project.name!)
        }
        
    }
        
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let strIdentifier = segue.identifier else {
            return
        }
        switch strIdentifier {
        case Segues.ToJobs.rawValue:
            
            guard let jobsVC = segue.destinationViewController as? JobsViewControllerProtocol else {
                break
            }
            
            jobsVC.project = projectSelected
            jobsVC.jobModels = jobModels
            
        case Segues.ToScanner.rawValue:
            
            guard let scanVC = segue.destinationViewController as? ScanViewController else {
                break
            }
            
            scanVC.scanDelegate = self
            
        default:
            break
        }
    }
    
    // MARK: - ScanViewControllerProtocol
    
    func didScannedQRCode(code: NSString) {
        
        let projectName = code.lastPathComponent
        
        if !(UIApplication.sharedApplication().delegate as! AppDelegate).coreDataManager.saveProject(projectName) {
            let alert = UIAlertController(title: "Warning!", message: "Project already scanned", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(400 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        try! projectsFetchController.performFetch()
        projectListTableView.reloadData()
        checkIfProjectsAvailable()
        
        let endpoint = code.stringByReplacingOccurrencesOfString(projectName, withString: "")
        
        SettingsManager.saveEndPoint(endpoint)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initializeNetworkManager(endpoint)
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
}
