//
//  GKClock.m
//
//  Created by Jacky on 15/2/10.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "GKClock.h"
#import "GKClockWeatherManager.h"

@interface GKClock() <GKClockWeatherManagerDelegate>

@end

@implementation GKClock{
    
    CGFloat                 _radius;
    UIImageView             *_hourHandImageView;
    UIImageView             *_minuteHandImageView;
    UIImageView             *_secondHandImageView;
    UIImageView             *_conditionsImageView;
    NSCalendar              *_calendar;
    dispatch_source_t       _timer;
    GKClockWeatherManager   *_weatherManager;
    
}

#pragma mark -- Init Methods

- (id)init {
    if (self = [super init]) {
        [self initStyle];
        [self initTimer];
        [self initWeatherManager];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initStyle];
        [self initTimer];
        [self initWeatherManager];
    }
    
    return self;
}

- (void)initStyle {
    self.backgroundColor = [UIColor clearColor];
    
    _clockTintColor = [UIColor blackColor];
    _clockBorderWidth = 2.0f;
    _clockBorderColor = [UIColor whiteColor];
    
    _hourHandColor = [UIColor lightGrayColor];
    _hourHandWidth = 7.f;
    
    _minuteHandColor = [UIColor lightGrayColor];
    _minuteHandWidth = 5.f;
    
    _secondHandColor = [UIColor redColor];
    _secondHandWidth = 3.f;
    
    _momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:40],
                             NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    _momentList = @[@"12" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    
    _centerPointColor = [UIColor lightGrayColor];
    _centerPointRadius = 10.f;
    
    _calendar = [NSCalendar currentCalendar];
}

- (void)initTimer {
    dispatch_queue_t queue = dispatch_queue_create("com.gkclock.queue", DISPATCH_QUEUE_SERIAL);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC, 0);
    __weak GKClock *weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong GKClock *strongSelf = weakSelf;
            [strongSelf updateClock];
        });
        
    });
}

- (void)initWeatherManager {
    _weatherManager = [GKClockWeatherManager sharedManager];
    _weatherManager.delegate = self;
}


#pragma mark -- Draw Clock Methods

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetStrokeColorWithColor(context, self.clockBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.clockTintColor.CGColor);
    CGContextSetLineWidth(context, self.clockBorderWidth);
    _radius = (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / 2 : self.frame.size.height / 2;
    _radius = _radius - self.clockBorderWidth;
    CGContextAddArc(context,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2, _radius, 0.f, 2 * M_PI, 0.f);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    /* 获取表盘刻度位置列表 */
    NSArray *momentPointList = [self momentRectList];
    
    /* 绘制表盘刻度 */
    for (NSInteger i = 0; i < self.momentList.count; i++) {
        NSString *momentStr = self.momentList[i];
        CGPoint momentPoint = [momentPointList[i] CGPointValue];
        [momentStr drawAtPoint:momentPoint withAttributes:_momentAttribute];
    }
    
    /* 绘制表盘指针 */
    [self drawClockHand];
    
    /* 定位并获取本地天气 */
    [_weatherManager fetchCurrentConditions];
}

/**
 *  绘制表针
 */
- (void)drawClockHand {
    UIImage *hourHandImage = [self drawHourHand];
    UIImage *minuteHandImage = [self drawMinuteHand];
    UIImage *secondHandImage = [self drawSecondHand];
    UIImage *centerPointImage = [self drawCenterPoint];
    
    CGPoint handArchorPoint = CGPointMake(0.5f, 1.f);
    
    CGSize hourHandSize = hourHandImage.size;
    CGSize minuteHandSize = minuteHandImage.size;
    CGSize secondHandSize = secondHandImage.size;
    CGSize centerPointSize = centerPointImage.size;
    
    /* 添加天气到表盘 */
    _conditionsImageView = [[UIImageView alloc] init];
    _conditionsImageView.contentMode = UIViewContentModeScaleAspectFit;
    _conditionsImageView.frame = CGRectMake(0.f,
                                            CGRectGetHeight(self.frame) / 2 - 0.6f * CGRectGetWidth(self.frame) / 2,
                                            CGRectGetWidth(self.frame) / 2,
                                            CGRectGetWidth(self.frame) / 8);
    _conditionsImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, _conditionsImageView.center.y);
    [self addSubview:_conditionsImageView];
    
    /* 添加时针到表盘 */
    _hourHandImageView = [[UIImageView alloc] initWithImage:hourHandImage];
    _hourHandImageView.contentMode = UIViewContentModeTop;
    _hourHandImageView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - hourHandSize.width / 2,
                                 CGRectGetHeight(self.frame) / 2 - hourHandSize.height /2,
                                 hourHandSize.width,
                                 hourHandSize.height);
    _hourHandImageView.layer.shouldRasterize = YES;
    _hourHandImageView.layer.anchorPoint = handArchorPoint;
    [self addSubview:_hourHandImageView];
    
    /* 添加分针到表盘 */
    _minuteHandImageView = [[UIImageView alloc] initWithImage:minuteHandImage];
    _minuteHandImageView.contentMode = UIViewContentModeTop;
    _minuteHandImageView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - minuteHandSize.width / 2,
                                   CGRectGetHeight(self.frame) / 2 - minuteHandSize.height / 2,
                                   minuteHandSize.width,
                                   minuteHandSize.height);
    _minuteHandImageView.layer.shouldRasterize = YES;
    _minuteHandImageView.layer.anchorPoint = handArchorPoint;
    [self addSubview:_minuteHandImageView];
    
    /* 添加秒针到表盘 */
    _secondHandImageView = [[UIImageView alloc] initWithImage:secondHandImage];
    _secondHandImageView.contentMode = UIViewContentModeTop;
    _secondHandImageView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - secondHandSize.width / 2,
                                   CGRectGetHeight(self.frame) / 2 - secondHandSize.height / 2,
                                   secondHandSize.width,
                                   secondHandSize.height);
    _secondHandImageView.layer.shouldRasterize = YES;
    _secondHandImageView.layer.anchorPoint = handArchorPoint;
    [self addSubview:_secondHandImageView];
    
    /* 添加中心圆点到表盘 */
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:centerPointImage];
    centerImageView.layer.shouldRasterize = YES;
    centerImageView.contentMode = UIViewContentModeCenter;
    centerImageView.frame = CGRectMake(0, 0, centerPointSize.width, centerPointSize.height);
    centerImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:centerImageView];
    
}

/**
 *  绘制时针
 *
 *  @return 绘制生成的时针图片
 */
- (UIImage *)drawHourHand {
    CGSize hourHandSize = CGSizeMake(self.hourHandWidth, _radius * 2.5 / 5);
    UIGraphicsBeginImageContextWithOptions(hourHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, hourHandSize.width, hourHandSize.height)
                                                     cornerRadius:self.hourHandWidth / 2];
    [self.hourHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  绘制分针
 *
 *  @return 绘制生成的分针图片
 */
- (UIImage *)drawMinuteHand {
    CGSize minuteHandSize = CGSizeMake(self.minuteHandWidth, _radius * 3.5 / 5);
    UIGraphicsBeginImageContextWithOptions(minuteHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, minuteHandSize.width, minuteHandSize.height)
                                                     cornerRadius:self.minuteHandWidth / 2];
    [self.minuteHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  绘制秒针
 *
 *  @return 绘制生成的秒针图片
 */
- (UIImage *)drawSecondHand {
    CGSize secondHandSize = CGSizeMake(self.secondHandWidth, _radius * 4 / 5);
    UIGraphicsBeginImageContextWithOptions(secondHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, secondHandSize.width, secondHandSize.height)
                                                     cornerRadius:self.secondHandWidth / 2];
    [_secondHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  绘制中心原点
 *
 *  @return 绘制生成的原点图片
 */
- (UIImage *)drawCenterPoint {
    CGSize centerPointSize = CGSizeMake(2 * self.centerPointRadius, 2 * self.centerPointRadius);
    UIGraphicsBeginImageContextWithOptions(centerPointSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, centerPointSize.width, centerPointSize.height)
                                                     cornerRadius:self.centerPointRadius];
    [self.centerPointColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  计算刻度位置
 *
 *  @return 刻度位置数组
 */
- (NSArray *)momentRectList {
    NSMutableArray *pointList = [NSMutableArray array];
    CGRect maxfontRect = [self.momentList[0] boundingRectWithSize:CGSizeMake(_radius, MAXFLOAT)
                                                          options:0
                                                       attributes:self.momentAttribute
                                                          context:nil];
    CGFloat samllerRadius = _radius - MAX(maxfontRect.size.width / 2, maxfontRect.size.height/2);
    for (NSInteger i = 0; i < 12; i++) {
        NSString *momentStr = self.momentList[i];
        CGRect fontRect = [momentStr boundingRectWithSize:CGSizeMake(_radius, MAXFLOAT)
                                                  options:0
                                               attributes:self.momentAttribute
                                                  context:nil];
        CGFloat angle = i * 30;
        CGFloat x = CGRectGetWidth(self.frame) / 2 + samllerRadius * sin(angle * M_PI / 180.f) - fontRect.size.width / 2;
        CGFloat y = CGRectGetHeight(self.frame) / 2 - samllerRadius * cos(angle * M_PI / 180.f) - fontRect.size.height / 2 ;
        
        [pointList addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    return pointList;
}

#pragma mark -- Clock Manage Methods
/**
 *  启动定时器
 */
- (void)start {
    dispatch_resume(_timer);
}

/**
 *  定制定时器
 */
- (void)stop {
    dispatch_suspend(_timer);
}

/**
 *  更新表盘指针角度，让指针转起来
 */
- (void)updateClock {
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [_calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    /* 计算表针每秒钟转动的角度 */
    CGFloat hourAngle =  30.f * (dateComponents.hour + (CGFloat)dateComponents.minute / 60); // 每小时转动的角度*（当前的小时数 + 当前的分钟数转化的小时数）
    CGFloat minuteAngle = 6.f * dateComponents.minute;  // 每分钟转动的角度*当前分钟数
    CGFloat secondAngle = 6.f * dateComponents.second;  // 每秒钟转动的角度*当前秒数
    
    /* 验证转动的度数是否大于360度 */
    hourAngle = hourAngle > 360.f ? hourAngle - 360.f : hourAngle;
    minuteAngle = minuteAngle > 360.f ? minuteAngle - 360.f : minuteAngle;
    secondAngle = secondAngle > 360.f ? secondAngle - 360.f : secondAngle;
    
    /* 旋转表针，并添加动画 */
    [UIView animateWithDuration:0.075 animations:^{
        _hourHandImageView.transform = CGAffineTransformMakeRotation(hourAngle * (M_PI / 180.f));
        _minuteHandImageView.transform = CGAffineTransformMakeRotation(minuteAngle * (M_PI / 180.f));
        _secondHandImageView.transform = CGAffineTransformMakeRotation(secondAngle * (M_PI / 180.f));
    }];
}

#pragma mark -- WeatherManager Delegate Methods

- (void)fetchWeatherConditionsSuccess:(NSString *)iconName {
    UIImage *conditionsImage = [UIImage imageNamed:iconName];
    dispatch_async(dispatch_get_main_queue(), ^{
      _conditionsImageView.image = conditionsImage;
    });
}

- (void)fetchWeatherConditionsFailed:(NSError *)error {
    NSLog(@"获取天气数据失败:%@", error);
}

@end
