//
//  CustomHeader.m
//  MyCoreData
//
//  Created by Watchara Thongkam on 5/31/55 BE.
//  Copyright (c) 2555 ever free Inc. All rights reserved.
//

#import "CustomHeader.h"
#import "Common.h"

@implementation CustomHeader
@synthesize titleLabel = _titleLabel;
@synthesize lightColor = _lightColor;
@synthesize darkColor = _darkColor;


- (id)init 
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
         _titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        [self addSubview:_titleLabel];
        
        self.lightColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f blue:216.0f/255.0f alpha:1.0];
        self.darkColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews 
{
    CGFloat coloredBoxMargin = 6.0;
    CGFloat coloredBoxHeight = 40.0;
    coloredBoxRect = CGRectMake(coloredBoxMargin, 
                                coloredBoxMargin, 
                                self.bounds.size.width-coloredBoxMargin*2, 
                                coloredBoxHeight);
    
    CGFloat paperMargin = 9.0;
    paperRect = CGRectMake(paperMargin, 
                            CGRectGetMaxY(coloredBoxRect), 
                            self.bounds.size.width - paperMargin * 2, 
                            self.bounds.size.height-CGRectGetMaxY(coloredBoxRect));
    
    _titleLabel.frame = coloredBoxRect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 
                                             blue:1.0 alpha:1.0].CGColor;
    CGColorRef lightColor = _lightColor.CGColor;
    CGColorRef darkColor = _darkColor.CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 
                                              blue:0.2 alpha:0.5].CGColor; 
    
    CGContextSetFillColorWithColor(context, whiteColor);
    CGContextFillRect(context, paperRect);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGContextSetFillColorWithColor(context, lightColor);
    CGContextFillRect(context, coloredBoxRect);
    CGContextRestoreGState(context);
    
    drawGlossAndGradient(context, coloredBoxRect, lightColor, darkColor);
    
    // Draw stroke
    CGContextSetStrokeColorWithColor(context, darkColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, rectFor1PxStroke(coloredBoxRect));
}


@end
