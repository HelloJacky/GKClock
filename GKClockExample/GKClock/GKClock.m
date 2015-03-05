//
//  GKClock.m
//
//  Created by Jacky on 15/2/10.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "GKClock.h"

@interface GKClock()
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIImageView *hourHand;
@property (nonatomic, strong) UIImageView *minuteHand;
@property (nonatomic, strong) UIImageView *secondHand;

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) dispatch_source_t timer;

@end
@implementation GKClock

#pragma mark -- Init Methods
- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        _clockTintColor = [UIColor blackColor];
        _clockBorderWidth = 2.0f;
        _clockBorderColor = [UIColor whiteColor];
        
        _hourHandColor = [UIColor lightGrayColor];
        _minuteHandColor = [UIColor lightGrayColor];
        _secondHandColor = [UIColor redColor];
        
        _momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:40],
                             NSForegroundColorAttributeName : [UIColor whiteColor]};
        
        _momentList = @[@"12" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
        
        _centerPointColor = [UIColor lightGrayColor];
        _calendar = [NSCalendar currentCalendar];
        
        [self initTimer];
    }
    return self;
}

- (void)initTimer{
    dispatch_queue_t queue = dispatch_queue_create("Clock Timer Run Queue", 0);
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


#pragma mark -- Draw Clock Methods

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetStrokeColorWithColor(context, _clockBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, _clockTintColor.CGColor);
    CGContextSetLineWidth(context, _clockBorderWidth);
    _radius = (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / 2 : self.frame.size.height / 2;
    _radius = _radius - _clockBorderWidth;
    CGContextAddArc(context,CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2, _radius, 0.f, 2 * M_PI, 0.f);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSArray *momentPointList = [self momentRectList];
    //绘制表盘刻度
    for (NSInteger i = 0; i < _momentList.count; i++) {
        NSString *momentStr = _momentList[i];
        CGPoint momentPoint = [momentPointList[i] CGPointValue];
        [momentStr drawAtPoint:momentPoint withAttributes:_momentAttribute];
    }
    //    CGContextRelease(context);
    
    //绘制表盘指针
    [self drawClockHand];
}

- (void)drawClockHand{
    UIImage *hourHandImage = [self drawHourHand];
    UIImage *minuteHandImage = [self drawMinuteHand];
    UIImage *secondHandImage = [self drawSecondHand];
    UIImage *centerPointImage = [self drawCenterPoint];
    
    CGSize hourHandSize = hourHandImage.size;
    CGSize minuteHandSize = minuteHandImage.size;
    CGSize secondHandSize = secondHandImage.size;
    CGSize centerPointSize = centerPointImage.size;
    
    //添加时针到表盘
    _hourHand = [[UIImageView alloc] initWithImage:hourHandImage];
    _hourHand.contentMode = UIViewContentModeTop;
    _hourHand.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - hourHandSize.width/2,
                                 CGRectGetHeight(self.frame)/2 - hourHandSize.height,
                                 hourHandSize.width,
                                 hourHandSize.height * 2);
    _hourHand.layer.shouldRasterize = YES;
    [self addSubview:_hourHand];
    
    //添加分针到表盘
    _minuteHand = [[UIImageView alloc] initWithImage:minuteHandImage];
    _minuteHand.contentMode = UIViewContentModeTop;
    _minuteHand.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - minuteHandSize.width / 2,
                                   CGRectGetHeight(self.frame)/2 - minuteHandSize.height,
                                   minuteHandSize.width,
                                   minuteHandSize.height * 2);
    _minuteHand.layer.shouldRasterize = YES;
    [self addSubview:_minuteHand];
    
    //添加秒针到表盘
    _secondHand = [[UIImageView alloc] initWithImage:secondHandImage];
    _secondHand.contentMode = UIViewContentModeTop;
    _secondHand.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - secondHandSize.width / 2,
                                   CGRectGetHeight(self.frame)/2 - secondHandSize.height,
                                   secondHandSize.width,
                                   secondHandSize.height * 2);
    _secondHand.layer.shouldRasterize = YES;
    [self addSubview:_secondHand];
    
    //添加中心圆点到表盘
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:centerPointImage];
    centerImageView.layer.shouldRasterize = YES;
    centerImageView.contentMode = UIViewContentModeCenter;
    centerImageView.frame = CGRectMake(0, 0, centerPointSize.width, centerPointSize.height);
    centerImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [self addSubview:centerImageView];
    
}

- (UIImage *)drawHourHand{
    CGSize hourHandSize = CGSizeMake(7.f, _radius * 2.5 / 5);
    UIGraphicsBeginImageContextWithOptions(hourHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, hourHandSize.width, hourHandSize.height)];
    [_hourHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawMinuteHand{
    CGSize minuteHandSize = CGSizeMake(5.f, _radius * 3.5/ 5);
    UIGraphicsBeginImageContextWithOptions(minuteHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, minuteHandSize.width, minuteHandSize.height)];
    [_minuteHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawSecondHand{
    CGSize secondHandSize = CGSizeMake(3.f, _radius * 4 / 5);
    UIGraphicsBeginImageContextWithOptions(secondHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, secondHandSize.width, secondHandSize.height)];
    [_secondHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawCenterPoint{
    CGSize centerPointSize = CGSizeMake(20.f, 20.f);
    UIGraphicsBeginImageContextWithOptions(centerPointSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, centerPointSize.width, centerPointSize.height)
                                                     cornerRadius:centerPointSize.height/2];
    [_centerPointColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray *)momentRectList{
    NSMutableArray *pointList = [NSMutableArray array];
    CGRect maxfontRect = [_momentList[0] boundingRectWithSize:CGSizeMake(_radius, MAXFLOAT)
                                                      options:0
                                                   attributes:_momentAttribute
                                                      context:nil];
    CGFloat samllerRadius = _radius - MAX(maxfontRect.size.width/2, maxfontRect.size.height/2);
    for (NSInteger i = 0; i < 12; i++) {
        NSString *momentStr = _momentList[i];
        CGRect fontRect = [momentStr boundingRectWithSize:CGSizeMake(_radius, MAXFLOAT)
                                                  options:0
                                               attributes:_momentAttribute
                                                  context:nil];
        
        CGFloat angle = i * 30;
        CGFloat x = CGRectGetWidth(self.frame)/2 + samllerRadius * sin(angle * M_PI / 180.f) - fontRect.size.width / 2;
        CGFloat y = CGRectGetHeight(self.frame)/2 - samllerRadius * cos(angle * M_PI / 180.f) - fontRect.size.height / 2 ;
        
        [pointList addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    return pointList;
}

#pragma mark -- Clock Manage Methods
- (void)start{
    dispatch_resume(_timer);
}

- (void)stop{
    dispatch_suspend(_timer);
}

- (void)updateClock{
    NSDate *date = [NSDate date];
    
    NSDateComponents *dateComponents = [_calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    CGFloat hourAngle =  0.5 * (60.f * dateComponents.hour + dateComponents.minute);
    CGFloat minuteAngle = 6.f * dateComponents.minute;
    CGFloat secondAngle = 6.f * dateComponents.second;
    hourAngle = hourAngle > 360.f ? hourAngle - 360.f : hourAngle;
    minuteAngle = minuteAngle > 360.f ? minuteAngle - 360.f : minuteAngle;
    secondAngle = secondAngle > 360.f ? secondAngle - 360.f : secondAngle;
    [UIView animateWithDuration:0.075 animations:^{
        _hourHand.transform = CGAffineTransformMakeRotation(hourAngle * (M_PI / 180.f));
        _minuteHand.transform = CGAffineTransformMakeRotation(minuteAngle * (M_PI / 180.f));
        _secondHand.transform = CGAffineTransformMakeRotation(secondAngle * (M_PI / 180.f));
    }];
}
@end
