//
//  ItemsViewController.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController //<NSFetchedResultsControllerDelegate> 
{
    //NSManagedObjectContext *context;
    //NSFetchedResultsController *fetchedResultsController;
}
@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
