//
//  ProjectsListViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit
import CoreData

class ProjectsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var projectListTableView: UITableView!
    
    var projectsFetchController: NSFetchedResultsController!
    
    var projectSelected: Project?
    
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
        
        // Show/Hide projectListTableView/noProjectsLabel
        let entriesAvailable = projectsFetchController.sections![0].numberOfObjects > 0
        projectListTableView.hidden = !entriesAvailable
        noProjectsLabel.hidden = entriesAvailable
        
        projectListTableView.registerClass(ProjectTableViewCell.self, forCellReuseIdentifier: TableViewCells.ProjectCell.rawValue)
        projectListTableView.dataSource = self
        projectListTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        projectSelected = projectsFetchController.objectAtIndexPath(indexPath) as? Project
        performSegueWithIdentifier(Segues.ToJobs.rawValue, sender: self)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case Segues.ToJobs.rawValue:
            
            guard let jobsVC = segue.destinationViewController as? JobsViewControllerProtocol else {
                break
            }
            
            jobsVC.project = projectSelected
            
        default:
            break
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate

    
    
}
