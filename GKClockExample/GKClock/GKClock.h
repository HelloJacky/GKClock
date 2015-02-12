//
//  GKClock.h
//
//  Created by Jacky on 15/2/10.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKClock : UIView

@property (nonatomic, strong) UIColor *clockTintColor;
@property (nonatomic, assign) CGFloat clockBorderWidth;
@property (nonatomic, strong) UIColor *clockBorderColor;

@property (nonatomic, strong) UIColor *hourHandColor;
@property (nonatomic, strong) UIColor *minuteHandColor;
@property (nonatomic, strong) UIColor *secondHandColor;

@property (nonatomic, strong) NSDictionary *momentAttribute;
@property (nonatomic, strong) NSArray *momentList;

- (void)start;
- (void)stop;

@end
