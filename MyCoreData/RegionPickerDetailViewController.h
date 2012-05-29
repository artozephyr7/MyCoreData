//
//  RegionPickerDetailViewController.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/20/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBItem;

@interface RegionPickerDetailViewController : UIViewController <UITextFieldDelegate> 
{
    __weak IBOutlet UITextField *regionNameField;
}

@property (nonatomic, strong) SBItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
