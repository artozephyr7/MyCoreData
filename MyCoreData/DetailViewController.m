//
//  DetailViewController.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "DetailViewController.h"
#import "SBItemStore.h"
#import "SBItem.h"
#import "RegionPicker.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize item;
@synthesize dismissBlock;
@synthesize context;


- (void)setItem:(SBItem *)i 
{
    if (item != i) {
        item = i;
        [[self navigationItem] setTitle:[item name]];
    }
}

- (void)save:(id)sender 
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender 
{
    [[SBItemStore sharedStore] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (id)initForNewItem:(BOOL)isNew 
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
            //SBItemStore *ps = [SBItemStore sharedStore];
            //self.context = ps.context;
        }
    }
    return self;
}

- (IBAction)backgroundTapped:(id)sender 
{
    [[self view] endEditing:YES];
}

- (IBAction)showRegionPicker:(id)sender 
{
    [[self view] endEditing:YES];
    
    RegionPicker *regionPicker = [[RegionPicker alloc] init];
    [regionPicker setItem:item];
    //regionPicker.context = self.context;
    
    [[self navigationController] pushViewController:regionPicker animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    nameField = nil;
    addressField = nil;
    phoneNumberField = nil;
    latitudeField = nil;
    longitudeField = nil;
    regionButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item name]];
    [addressField setText:[item address]];
    [phoneNumberField setText:[item phoneNumber]];
    
    [latitudeField setText:[NSString stringWithFormat:@"%.8f", [item latitude]]];
    [longitudeField setText:[NSString stringWithFormat:@"%.8f", [item longitude]]];
    
    NSString *regionName = [[item region] valueForKey:@"name"];
    if (!regionName) {
        regionName = @"None";
    }
    
    [regionButton setTitle:[NSString stringWithFormat:@"Region: %@", regionName] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    [item setName:[nameField text]];
    [item setAddress:[addressField text]];
    [item setPhoneNumber:[phoneNumberField text]];
    [item setLatitude:[[latitudeField text] doubleValue]];
    [item setLongitude:[[longitudeField text] doubleValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

@end
