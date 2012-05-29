//
//  RegionPicker.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/20/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBItem;

@interface RegionPicker : UITableViewController //<NSFetchedResultsControllerDelegate> 

@property (nonatomic, strong) SBItem *item;

@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end
