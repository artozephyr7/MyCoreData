//
//  DetailViewController.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *addressField;
    __weak IBOutlet UITextField *phoneNumberField;
    __weak IBOutlet UITextField *latitudeField;
    __weak IBOutlet UITextField *longitudeField;
    __weak IBOutlet UIButton *regionButton;
}

@property (nonatomic, strong) SBItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) NSManagedObjectContext *context;

- (id)initForNewItem:(BOOL)isNew;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)showRegionPicker:(id)sender;

@end
