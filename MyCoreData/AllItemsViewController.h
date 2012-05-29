//
//  AllItemsViewController.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/28/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllItemsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
