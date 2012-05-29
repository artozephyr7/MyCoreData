//
//  RegionPicker.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/20/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "RegionPicker.h"
#import "SBItem.h"
#import "SBItemStore.h"
#import "RegionPickerDetailViewController.h"

@implementation RegionPicker
@synthesize item;
@synthesize context;
//@synthesize fetchedResultsController;


- (id)init 
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[self navigationItem] setTitle:@"Region"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRegion:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        //SBItemStore *ps = [SBItemStore sharedStore];
        //self.context = ps.context;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style 
{
    return [self init];
}

- (IBAction)addNewRegion:(id)sender 
{    
    RegionPickerDetailViewController *detailViewController = [[RegionPickerDetailViewController alloc] init];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    //detailViewController.context = self.context;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
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
 */

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    //[self performFetch];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    //fetchedResultsController = nil;
    //[fetchedResultsController setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [[self tableView] reloadData];
}

- (void)dealloc 
{
    //[fetchedResultsController setDelegate:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[[SBItemStore sharedStore] allRegions] count];
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    NSArray *allRegions = [[SBItemStore sharedStore] allRegions];
    NSManagedObject *region = [allRegions objectAtIndex:[indexPath row]];
    //NSManagedObject
    //NSManagedObject *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Use key-value coding to get the region's name
    NSString *regionName = [region valueForKey:@"name"];
    [[cell textLabel] setText:regionName];
    
    // Checkmark the one that is currently selected
    if (region == [item region]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SBItemStore *ps = [SBItemStore sharedStore];
        NSArray *items = [ps allRegions];
        //SBItem *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
        SBItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeRegion:p];
        [ps saveChanges];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSArray *allRegions = [[SBItemStore sharedStore] allRegions];
    NSManagedObject *region = [allRegions objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //NSManagedObject
    //NSManagedObject *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [item setRegion:region];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[self navigationController] popViewControllerAnimated:YES];
}



/*
#pragma mark - Fetched results controller Delegate

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (!fetchedResultsController) {
        // Create and configure a fetch request with the SBItem entity.
        SBItemStore *ps = [SBItemStore sharedStore];
        self.context = ps.context;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"SBRegion" inManagedObjectContext:self.context];
        [request setEntity:e];
        
        [request setFetchBatchSize:20];
        
        // Create the sort descriptors array.
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Create and initialize the fetch results controller
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"SBRegions"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [NSFetchedResultsController deleteCacheWithName:@"SBRegions"];
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
