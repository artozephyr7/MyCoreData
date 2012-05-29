//
//  AppDelegate.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
