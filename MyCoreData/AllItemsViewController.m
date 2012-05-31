//
//  AllItemsViewController.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/28/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "AllItemsViewController.h"
#import "SBItem.h"
#import "SBItemStore.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"

@interface AllItemsViewController ()

@end

@implementation AllItemsViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController;


- (id)init 
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        [self setTitle:@"All Stores"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)performFetch 
{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *backgroundImage = [UIImage imageNamed:@"main_bg.jpg"];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    [self performFetch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    fetchedResultsController = nil;
    [fetchedResultsController setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [[self tableView] reloadData];
}

- (void)dealloc 
{
    [fetchedResultsController setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath 
{
    SBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [[cell textLabel] setText:[item name]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    //[[cell detailTextLabel] setText:[item address]];
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundView = [[CustomCellBackground alloc] init];
        cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    }
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    CustomHeader *header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    // Default color is light blue
    if (section == 0 || section == 12 || section == 24 || section == 36) {
        // Blue
        header.lightColor = [UIColor colorWithRed:61.0/255.0 green:148.0/255.0 blue:206.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:20.0/255.0 green:126.0/255.0 blue:196.0/255.0 alpha:1.0];
    } else if (section == 1 || section == 13 || section == 25 || section == 37) {
        // Purple
        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
    } else if (section == 2 || section == 14 || section == 26 || section == 38) {
        // Green
        header.lightColor = [UIColor colorWithRed:70.0/255.0 green:150.0/255.0 blue:50.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:25.0/255.0 green:125.0/255.0 blue:92.0/255.0 alpha:1.0];
    } else if (section == 3 || section == 15 || section == 27 || section == 39) {
        // Red
        header.lightColor = [UIColor colorWithRed:216.0/255.0 green:40.0/255.0 blue:90.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:140.0/255.0 green:20.0/255.0 blue:30.0/255.0 alpha:1.0];
    } else if (section == 4 || section == 16 || section == 28 || section == 40) {
        // Yellow
        header.lightColor = [UIColor colorWithRed:255.0/255.0 green:236.0/255.0 blue:150.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if (section == 5 || section == 17 || section == 29 || section == 41) {
        // Orange
        header.lightColor = [UIColor colorWithRed:255.0/255.0 green:174.0/255.0 blue:78.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if (section == 6 || section == 18 || section == 30 || section == 42) {
        // Pink
        header.lightColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:210.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:200.0/255.0 green:40.0/255.0 blue:210.0/255.0 alpha:1.0];
    } else if (section == 7 || section == 19 || section == 31 || section == 43) {
        // Brown
        header.lightColor = [UIColor colorWithRed:135.0/255.0 green:98.0/255.0 blue:65.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:99.0/255.0 green:51.0/255.0 blue:7.0/255.0 alpha:1.0];
    } else if (section == 8 || section == 20 || section == 32 || section == 44) {
        // Gray
        header.lightColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
    }  else if (section == 9 || section == 21 || section == 33 || section == 45) {
        // Light green
        header.lightColor = [UIColor colorWithRed:173.0/255.0 green:255.0/255.0 blue:47.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if (section == 10 || section == 22 || section == 34 || section == 46) {
        // Dark gray
        header.lightColor = [UIColor colorWithRed:88.0/255.0 green:105.0/255.0 blue:114.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:59.0/255.0 green:78.0/255.0 blue:89.0/255.0 alpha:1.0];
    } else if (section == 11 || section == 23 || section == 35 || section == 47) {
        // Dark purple
        header.lightColor = [UIColor colorWithRed:123.0/255.0 green:57.0/255.0 blue:131.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:98.0/255.0 green:17.0/255.0 blue:106.0/255.0 alpha:1.0];
    } else {
        // Random color
        float rand_max = RAND_MAX;
        float red = rand() / rand_max;
        float green = rand() / rand_max;
        float blue = rand() / rand_max;
        header.lightColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        header.darkColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    return 50;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (fetchedResultsController) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SBItem" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"region.name" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"region.name" cacheName:@"AllItems"];
    [fetchedResultsController setDelegate:self];
    self.fetchedResultsController = aFetchedResultsController;
    
    [NSFetchedResultsController deleteCacheWithName:@"AllItems"];
    
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


@end
