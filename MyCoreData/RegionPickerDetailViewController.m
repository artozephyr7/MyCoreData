//
//  RegionPickerDetailViewController.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/20/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "RegionPickerDetailViewController.h"
#import "SBItem.h"
#import "SBItemStore.h"

@interface RegionPickerDetailViewController ()

@end

@implementation RegionPickerDetailViewController
@synthesize item;
@synthesize dismissBlock;
@synthesize context;


- (id)init 
{
    self = [super initWithNibName:@"RegionPickerDetailViewController" bundle:nil];
    if (self) {
        [[self navigationItem] setTitle:@"Add New Region"];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)save:(id)sender 
{
    SBItemStore *store = [SBItemStore sharedStore];
    [store createRegion:[regionNameField text]];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender 
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    regionNameField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    
    SBItemStore *store = [SBItemStore sharedStore];
    [store createRegion:[regionNameField text]];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    
    return YES;
}


@end
