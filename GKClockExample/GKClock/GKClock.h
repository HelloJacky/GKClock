//
//  GKClock.h
//
//  Created by Jacky on 15/2/10.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKClock : UIView

@property (nonatomic, strong) UIColor *clockTintColor;      //钟表表盘背景颜色
@property (nonatomic, assign) CGFloat clockBorderWidth;     //钟表边框宽度
@property (nonatomic, strong) UIColor *clockBorderColor;    //钟表边框颜色

@property (nonatomic, strong) UIColor *hourHandColor;       //时针颜色
@property (nonatomic, strong) UIColor *minuteHandColor;     //分针颜色
@property (nonatomic, strong) UIColor *secondHandColor;     //秒针颜色

@property (nonatomic, strong) NSDictionary *momentAttribute;    //刻度文字属性
@property (nonatomic, strong) NSArray *momentList;              //刻度文字列表

@property (nonatomic, strong) UIColor *centerPointColor;        //中心点的颜色

/**
 *  开始摆动
 */
- (void)start;

/**
 *  停止摆动
 */
- (void)stop;

@end
