//
//  SBItemStore.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "SBItemStore.h"
#import "SBItem.h"

@implementation SBItemStore
@synthesize context;


+ (SBItemStore *)sharedStore 
{
    static SBItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    return [self sharedStore];
}

- (id)init 
{
    self = [super init];
    if (self) {
        // Read in Starbucks.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // Where does the SQLite file go?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        /*
         Set up the store.
         For the sake of illustration, provide a pre-populated default store.
         */
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:[storeURL path]]) {
            NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"starbucks" withExtension:@"sqlite"];
            if (defaultStoreURL) {
                [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
            }
        }
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        self.context = [[NSManagedObjectContext alloc] init];
        [self.context setPersistentStoreCoordinator:psc];
        
        [self.context setUndoManager:nil];
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems 
{
    return allItems;
}

- (NSArray *)allRegions 
{   
    return allRegions;
}

- (SBItem *)createItem 
{
    double order;
    if ([allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
    
    SBItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"SBItem" inManagedObjectContext:self.context];
    
    [p setOrderingValue:order];
    [allItems addObject:p];
    
    return p;
}

- (void)removeItem:(SBItem *)p 
{
    [context deleteObject:p];
    [allItems removeObjectIdenticalTo:p];
}

- (BOOL)createRegion:(NSString *)regionName 
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setFetchLimit:1];
    
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"SBRegion"];
    [request setEntity:e];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", regionName];
    [request setPredicate:predicate];
    
    NSUInteger regionCount = [self.context countForFetchRequest:request error:nil];
    if (regionCount == 0) {
        NSManagedObject *region;
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:regionName forKey:@"name"];
        [allRegions addObject:region];
        return YES;
    } else {
        NSLog(@"Region name '%@' already exist", regionName);
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Region name '%@' already exist", regionName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        
        return NO;
    }
}

- (void)removeRegion:(SBItem *)p 
{
    [self.context deleteObject:p];
    [allRegions removeObjectIdenticalTo:p];
}


#pragma mark - Saving/Loading data

- (NSString *)itemArchivePath 
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"starbucks.sqlite"];
}

- (BOOL)saveChanges 
{
    NSError *error = nil;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems 
{
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"SBItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
    
    // Region
    if (!allRegions) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"SBRegion"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        allRegions = [result mutableCopy];
    }
    
    // Is this the first time the program is being run?
    if ([allRegions count] == 0) {
        NSManagedObject *region;
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"เชียงใหม่" forKey:@"name"];
        [allRegions addObject:region];
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"เชียงราย" forKey:@"name"];
        [allRegions addObject:region];
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"เพลินจิต วิทยุ" forKey:@"name"];
        [allRegions addObject:region];
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"ขอนแก่น นครราชสีมา อุบล หนองคาย" forKey:@"name"];
        [allRegions addObject:region];
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"คลองเตย" forKey:@"name"];
        [allRegions addObject:region];
        
        region = [NSEntityDescription insertNewObjectForEntityForName:@"SBRegion" inManagedObjectContext:self.context];
        [region setValue:@"งามวงศ์วาน" forKey:@"name"];
        [allRegions addObject:region];
    }
}

/*
- (void)performFetch 
{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
		return;
    }
}


#pragma mark - Fetched results controller Delegate

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (!fetchedResultsController) {
        // Create and configure a fetch request with the SBItem entity.
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"SBItem" inManagedObjectContext:context];
        [request setEntity:e];
        
        //NSManagedObject *region;
        // Use key-value coding to get the region's name
        //NSString *regionName = [[region valueForKey:@"region"] description];
        
        // Create the sort descriptors array.
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"region" ascending:YES];
        NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        [request setSortDescriptors:sortDescriptors];
        
        [request setFetchBatchSize:20];
        
        // Create and initialize the fetch results controller
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"SBItems"];
        [fetchedResultsController setDelegate:self];
    }
    
    return fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    NSLog(@"*** controllerWillChangeContent");
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath 
{
    UITableView *tableView = [self tableView];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeInsert");
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeDelete");
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeUpdate");
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeMove");
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type 
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeInsert");
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeDelete");
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    NSLog(@"*** controllerDidChangeContent");
    [[self tableView] endUpdates];
}
*/

@end
