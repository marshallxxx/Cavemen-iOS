//
//  Job+CoreDataProperties.h
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface Job (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Project *project;

@end

NS_ASSUME_NONNULL_END
