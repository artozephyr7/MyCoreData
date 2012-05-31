//
//  CustomHeader.h
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/31/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeader : UIView
{
    CGRect coloredBoxRect;
    CGRect paperRect;
}
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIColor *lightColor;
@property (strong, nonatomic) UIColor *darkColor;

@end
