//
//  AppDelegate.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "SBItemStore.h"
#import "ItemsViewController.h"
#import "AllItemsViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize context = _context;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
    AllItemsViewController *allItemsViewController = [[AllItemsViewController alloc] init];
    
    SBItemStore *ps = [SBItemStore sharedStore];
    allItemsViewController.managedObjectContext = ps.context;
    
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    UINavigationController *navcontroller2 = [[UINavigationController alloc] initWithRootViewController:allItemsViewController];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:navController1, navcontroller2, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:viewControllers];
    
    [[self window] setRootViewController:tabBarController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    BOOL success = [[SBItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the SBItem");
    } else {
        NSLog(@"Could not save any of the SBItem");
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL success = [[SBItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the SBItem");
    } else {
        NSLog(@"Could not save any of the SBItem");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    BOOL success = [[SBItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the SBItem");
    } else {
        NSLog(@"Could not save any of the SBItem");
    }
}

- (void)fatalCoreDataError:(NSError *)error
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Internal Error", nil)
                              message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
	[alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)theAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	abort();
}

@end
