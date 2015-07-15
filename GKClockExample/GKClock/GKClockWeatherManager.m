//
//  GKClockWeahterManager.m
//  GKClockExample
//
//  Created by Jacky on 15/7/14.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "GKClockWeatherManager.h"

@interface GKClockWeatherManager()

@end

@implementation GKClockWeatherManager {
    CLLocationManager *_locationManager;
    BOOL _isFirstUpdate;
    NSURLSession *_session;
}

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

- (void)fetchCurrentConditions {
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    _isFirstUpdate = YES;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){ // 如果没有授权则请求用户授权
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager startUpdatingLocation]; // 启动跟踪定位
}

#pragma mark -- CLLocationManagerDelegate Method

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!_isFirstUpdate) {
        return;
    }
    _isFirstUpdate = NO;
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy > 0) {
        [self fetchWeatherConditionsForLocation:location.coordinate];  // 获取当前位置天气
        [_locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark -- NetWork

- (void)fetchWeatherConditionsForLocation:(CLLocationCoordinate2D)coordinate{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 if (!error) {
                                                     NSError *jsonError = nil;
                                                     id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                                                     if (!jsonError) {
                                                         [self handleJSONData:json];
                                                     }else{
                                                         [self.delegate fetchWeatherConditionsFailed:jsonError];
                                                     }
                                                 }else{
                                                     [self.delegate fetchWeatherConditionsFailed:error];
                                                 }
                                             }];
    [dataTask resume];
}

- (void)handleJSONData:(id)json {
    NSLog(@"%@", json);
    NSDictionary *jsonDictionary = json;
    NSDictionary *weatherDictionary = [jsonDictionary[@"weather"] firstObject];
    NSString *iconName = weatherDictionary[@"icon"];
    NSString *imageName = [self imageMap][iconName];
    [self.delegate fetchWeatherConditionsSuccess:imageName];
}

- (NSDictionary *)imageMap {
    static NSDictionary *imageMap = nil;
    if (!imageMap) {
        imageMap = @{
                     @"01d" : @"weather-clear",
                     @"02d" : @"weather-few",
                     @"03d" : @"weather-few",
                     @"04d" : @"weather-broken",
                     @"09d" : @"weather-shower",
                     @"10d" : @"weather-rain",
                     @"11d" : @"weather-tstorm",
                     @"13d" : @"weather-snow",
                     @"50d" : @"weather-mist",
                     @"01n" : @"weather-moon",
                     @"02n" : @"weather-few-night",
                     @"03n" : @"weather-few-night",
                     @"04n" : @"weather-broken",
                     @"09n" : @"weather-shower",
                     @"10n" : @"weather-rain-night",
                     @"11n" : @"weather-tstorm",
                     @"13n" : @"weather-snow",
                     @"50n" : @"weather-mist",
                     };
    }
    return imageMap;
}

@end
