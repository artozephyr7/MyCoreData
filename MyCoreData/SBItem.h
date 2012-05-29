//
//  SBItem.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/19/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SBItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *region;

@end
