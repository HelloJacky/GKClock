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
        _clockBorderWidth = 1.0f;
        _clockBorderColor = [UIColor whiteColor];
        
        _hourHandColor = [UIColor lightGrayColor];
        _minuteHandColor = [UIColor lightGrayColor];
        _secondHandColor = [UIColor redColor];
        

        
        _momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:40],
                             NSForegroundColorAttributeName : [UIColor whiteColor]};
        
        _momentList = @[@"12" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
        
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
    CGContextSetStrokeColorWithColor(context, _clockBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, _clockTintColor.CGColor);
    CGContextSetLineWidth(context, _clockBorderWidth);
    _radius = (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / 2 : self.frame.size.height / 2;
    CGContextAddArc(context, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), _radius, 0.f, 2 * M_PI, 0.f);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSArray *momentPointList = [self momentRectList];
    //draw moment
    for (NSInteger i = 0; i < _momentList.count; i++) {
        NSString *momentStr = _momentList[i];
        CGPoint momentPoint = [momentPointList[i] CGPointValue];
        [momentStr drawAtPoint:momentPoint withAttributes:_momentAttribute];
    }
    //    CGContextRelease(context);
    
    //draw clock hand and add
    [self drawClockHand];
}

- (void)drawClockHand{
    UIImage *hourHandImage = [self drawHourHand];
    UIImage *minuteHandImage = [self drawMinuteHand];
    UIImage *secondHandImage = [self drawSecondHand];
    
    CGSize hourHandSize = hourHandImage.size;
    CGSize minuteHandSize = minuteHandImage.size;
    CGSize secondHandSize = secondHandImage.size;
    
    //add hour hand
    _hourHand = [[UIImageView alloc] initWithImage:hourHandImage];
    _hourHand.contentMode = UIViewContentModeTop;
    _hourHand.frame = CGRectMake(CGRectGetMidX(self.frame) - hourHandSize.width/2,
                                 CGRectGetMidY(self.frame) - hourHandSize.height,
                                 hourHandSize.width,
                                 hourHandSize.height * 2);
    [self addSubview:_hourHand];
    
    //add minute hand
    _minuteHand = [[UIImageView alloc] initWithImage:minuteHandImage];
    _minuteHand.contentMode = UIViewContentModeTop;
    _minuteHand.frame = CGRectMake(CGRectGetMidX(self.frame) - minuteHandSize.width / 2,
                                   CGRectGetMidY(self.frame) - minuteHandSize.height,
                                   minuteHandSize.width,
                                   minuteHandSize.height * 2);
    [self addSubview:_minuteHand];
    
    //add second hand
    _secondHand = [[UIImageView alloc] initWithImage:secondHandImage];
    _secondHand.contentMode = UIViewContentModeTop;
    _secondHand.frame = CGRectMake(CGRectGetMidX(self.frame) - secondHandSize.width / 2,
                                   CGRectGetMidY(self.frame) - secondHandSize.height,
                                   secondHandSize.width,
                                   secondHandSize.height * 2);
    [self addSubview:_secondHand];
    
    
}

- (UIImage *)drawHourHand{
    CGSize hourHandSize = CGSizeMake(7.f, _radius * 3 / 5);
    UIGraphicsBeginImageContextWithOptions(hourHandSize, NO, [UIScreen mainScreen].scale);
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, hourHandSize.width, hourHandSize.height)];
    [_hourHandColor setFill];
    [bPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawMinuteHand{
    CGSize minuteHandSize = CGSizeMake(5.f, _radius * 4/ 5);
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
        CGFloat x = CGRectGetMidX(self.frame) + samllerRadius * sin(angle * M_PI / 180.f) - fontRect.size.width / 2;
        CGFloat y = CGRectGetMidY(self.frame) - samllerRadius * cos(angle * M_PI / 180.f) - fontRect.size.height / 2 ;
        
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
