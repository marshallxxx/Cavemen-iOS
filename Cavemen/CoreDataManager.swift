//
//  CoreDataManager.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation
import CoreData

enum DBEntities {
    case Projects
    case Jobs
    
    
    func getEntityName() -> String {
        switch self {
        case .Projects:
            return "Project"
        case .Jobs:
            return "Job"
        }
    }
    
}

class CoreDataManager {

    // MARK: Initialization of CoreData stack

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("CavemanDB", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: Directory location
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    // MARK: Core Data Dunctions
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save DB Context!")
        }
    }
    
    // MARK: Enteties
    
    func saveProject(projectName: String) -> Bool {
        
        let request = NSFetchRequest(entityName: DBEntities.Projects.getEntityName())
        let predicate = NSPredicate(format: "name == %@", projectName)
        request.predicate = predicate
        
        let results = try! managedObjectContext.executeFetchRequest(request)
        
        if results.count > 0 {
            return false
        }
        
        let project = NSEntityDescription.insertNewObjectForEntityForName(DBEntities.Projects.getEntityName(), inManagedObjectContext: managedObjectContext) as! Project
        project.name = projectName
        saveContext()
        
        return true
    }
    
    func removeProject(projectName: String) {
        let request = NSFetchRequest(entityName: DBEntities.Projects.getEntityName())
        let predicate = NSPredicate(format: "name == %@", projectName)
        request.predicate = predicate
        
        let results:[AnyObject]?
        
        do {
            results = try managedObjectContext.executeFetchRequest(request)
        } catch {
            return
        }
        
        if results != nil && results!.count > 0 {
            managedObjectContext.deleteObject(results![0] as! NSManagedObject)
            saveContext()
        }

    }
    
    //MARK: Fakes
    
    func populateDatabaseWithFakes() {
        let names = [ "Cavemen", "Endava", "Test" ]
        for name in names {
            let project = NSEntityDescription.insertNewObjectForEntityForName(DBEntities.Projects.getEntityName(), inManagedObjectContext: managedObjectContext) as! Project
            project.name = name
        }
        saveContext()
    }
    
    
}

