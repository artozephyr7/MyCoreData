//
//  ItemsViewController.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "ItemsViewController.h"
#import "SBItem.h"
#import "SBItemStore.h"


@implementation ItemsViewController
@synthesize context;
//@synthesize fetchedResultsController;


- (id)init 
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Starbucks"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        [self setTitle:@"Starbucks"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style 
{
    return [self init];
}

- (IBAction)addNewItem:(id)sender 
{
    SBItem *newItem = [[SBItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    [detailViewController setTitle:@"Add New Item"];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    //[fetchedResultsController setDelegate:nil];
}


#pragma mark - UITableViewDataSource

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[[SBItemStore sharedStore] allItems] count];
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    SBItem *item = [[[SBItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    //SBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:[item name]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%.8f, %.8f", [item latitude], [item longitude]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SBItemStore *ps = [SBItemStore sharedStore];
        NSArray *items = [ps allItems];
        SBItem *p = [items objectAtIndex:[indexPath row]];
        //SBItem *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [ps removeItem:p];
        [ps saveChanges];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[SBItemStore sharedStore] allItems];
    SBItem *selectedItem = [items objectAtIndex:[indexPath row]];
    //SBItem *selectedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [detailViewController setItem:selectedItem];
    
    //detailViewController.context = self.context;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


/*
#pragma mark - Fetched results controller Delegate

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (!fetchedResultsController) {
        // Create and configure a fetch request with the SBItem entity.
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"SBItem" inManagedObjectContext:self.context];
        [request setEntity:e];
        
        [request setFetchBatchSize:20];
        
        // Create the sort descriptors array.
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"region.name" ascending:YES];
        NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Create and initialize the fetch results controller
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"region.name" cacheName:@"SBItems"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [NSFetchedResultsController deleteCacheWithName:@"SBItems"];
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
