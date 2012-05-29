//
//  SBItemStore.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBItem;

@interface SBItemStore : NSObject 
{
    NSMutableArray *allItems;
    NSMutableArray *allRegions;
    //NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}
@property (nonatomic, strong) NSManagedObjectContext *context;

+ (SBItemStore *)sharedStore;

- (NSArray *)allItems;
- (NSArray *)allRegions;
- (SBItem *)createItem;
- (void)removeItem:(SBItem *)p;
- (BOOL)createRegion:(NSString *)regionName;
- (void)removeRegion:(SBItem *)p;

#pragma mark - Saving/Loading data
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
- (void)loadAllItems;

@end
