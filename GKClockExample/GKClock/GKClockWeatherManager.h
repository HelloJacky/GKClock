//
//  GKClockWeahterManager.h
//  GKClockExample
//
//  Created by Jacky on 15/7/14.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GKClockWeatherManagerDelegate <NSObject>
  @required
/**
 *  获取天气成功
 *
 *  @param iconName 当前天气对应的图片名称
 */
- (void)fetchWeatherConditionsSuccess:(NSString *)iconName;

/**
 *  获取天气失败
 *
 *  @param error 错误原因
 */
- (void)fetchWeatherConditionsFailed:(NSError *)error;

@end

@interface GKClockWeatherManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<GKClockWeatherManagerDelegate>delegate;

/**
 *  单例初始化方法
 *
 *  @return 当前实例
 */
+ (instancetype)sharedManager;

/**
 *  获取当前天气
 */
- (void)fetchCurrentConditions;

@end
