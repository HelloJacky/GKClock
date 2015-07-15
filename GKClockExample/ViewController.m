//
//  ViewController.m
//  GKClockExample
//
//  Created by Jacky on 15/2/10.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "ViewController.h"
#import "GKClock.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *clockList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clockList = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setupSmallClock];
    [self setupMiddleClock];
    [self setupBigClock];
    
    
    UIButton *switchButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.layer.borderWidth = 1.f;
    switchButton.layer.borderColor = [UIColor yellowColor].CGColor;
    switchButton.frame = CGRectMake(10.f, CGRectGetMaxY(self.view.frame) - 50.f, self.view.frame.size.width - 20.f, 40.f);
    [switchButton addTarget:self action:@selector(switchButtongClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setTitle:@"Stop" forState:UIControlStateNormal];
    [switchButton setTitle:@"Start" forState:UIControlStateSelected];
    [switchButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:switchButton];
}

- (void)setupSmallClock{
    CGFloat diameter = 80.f;
    CGFloat leftPadding = (CGRectGetWidth(self.view.frame) - 3 * diameter) / 4;
    
    //clock 1
    GKClock *clock1 = [[GKClock alloc] init];
    clock1.frame = CGRectMake(leftPadding, 20.f, diameter, diameter);
    [self.view addSubview:clock1];
    [clock1 start];
    
    clock1.clockBorderWidth = 1.f;
    clock1.clockBorderColor = [UIColor redColor];
    
    clock1.hourHandColor = [UIColor redColor];
    clock1.hourHandWidth = 3.f,
    
    clock1.minuteHandColor = [UIColor redColor];
    clock1.minuteHandWidth = 2.f;
    
    clock1.secondHandColor = [UIColor redColor];
    clock1.secondHandWidth = 1.f;
    
    clock1.centerPointColor = [UIColor redColor];
    clock1.centerPointRadius = 4.f;
    clock1.momentAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:10.f],
                                    NSForegroundColorAttributeName : [UIColor redColor]};
    
    //clock 2
    GKClock *clock2 = [[GKClock alloc] init];
    clock2.frame = CGRectMake(CGRectGetMaxX(clock1.frame) + leftPadding, 20.f, diameter, diameter);
    [self.view addSubview:clock2];
    [clock2 start];

    clock2.clockBorderWidth = 1.f;
    clock2.clockBorderColor = [UIColor yellowColor];
    
    clock2.hourHandColor = [UIColor yellowColor];
    clock2.hourHandWidth = 3.f,
    
    clock2.minuteHandColor = [UIColor yellowColor];
    clock2.minuteHandWidth = 2.f;
    
    clock2.secondHandColor = [UIColor yellowColor];
    clock2.secondHandWidth = 1.f;
    
    clock2.centerPointColor = [UIColor yellowColor];
    clock2.centerPointRadius = 4.f;
    clock2.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:10.f],
                               NSForegroundColorAttributeName : [UIColor yellowColor]};
    
    //clock 3
    GKClock *clock3 = [[GKClock alloc] init];
    clock3.frame = CGRectMake(CGRectGetMaxX(clock2.frame) + leftPadding, 20.f, diameter, diameter);
    [self.view addSubview:clock3];
    [clock3 start];
    
    clock3.clockBorderWidth = 1.f;
    clock3.clockBorderColor = [UIColor cyanColor];
    
    clock3.hourHandColor = [UIColor cyanColor];
    clock3.hourHandWidth = 3.f,
    
    clock3.minuteHandColor = [UIColor cyanColor];
    clock3.minuteHandWidth = 2.f;
    
    clock3.secondHandColor = [UIColor cyanColor];
    clock3.secondHandWidth = 1.f;
    
    clock3.centerPointColor = [UIColor cyanColor];
    clock3.centerPointRadius = 4.f;
    clock3.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"Papyrus" size:10.f],
                               NSForegroundColorAttributeName : [UIColor cyanColor]};
    
    [self.clockList addObjectsFromArray:@[clock1, clock2, clock3]];
}

- (void)setupMiddleClock{
    CGFloat diameter = 150.f;
    CGFloat leftPadding = (CGRectGetWidth(self.view.frame) - 2 * diameter) / 3;
    
    //clock 1
    GKClock *clock1 = [[GKClock alloc] init];
    clock1.frame = CGRectMake(leftPadding, 120.f, diameter, diameter);
    [self.view addSubview:clock1];
    [clock1 start];
    
    clock1.clockBorderWidth = 1.f;
    clock1.clockBorderColor = [UIColor orangeColor];
    
    clock1.hourHandColor = [UIColor orangeColor];
    clock1.hourHandWidth = 3.f,
    
    clock1.minuteHandColor = [UIColor orangeColor];
    clock1.minuteHandWidth = 2.f;
    
    clock1.secondHandColor = [UIColor orangeColor];
    clock1.secondHandWidth = 1.f;
    
    clock1.centerPointColor = [UIColor orangeColor];
    clock1.centerPointRadius = 4.f;
    clock1.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"Chalkduster" size:16.f],
                               NSForegroundColorAttributeName : [UIColor orangeColor]};
    
    //clock 2
    GKClock *clock2 = [[GKClock alloc] init];
    clock2.frame = CGRectMake(CGRectGetMaxX(clock1.frame) + leftPadding, 120.f, diameter, diameter);
    [self.view addSubview:clock2];
    [clock2 start];
    
    clock2.clockBorderWidth = 1.f;
    clock2.clockBorderColor = [UIColor greenColor];
    
    clock2.hourHandColor = [UIColor greenColor];
    clock2.hourHandWidth = 3.f,
    
    clock2.minuteHandColor = [UIColor greenColor];
    clock2.minuteHandWidth = 2.f;
    
    clock2.secondHandColor = [UIColor greenColor];
    clock2.secondHandWidth = 1.f;
    
    clock2.centerPointColor = [UIColor greenColor];
    clock2.centerPointRadius = 4.f;
    clock2.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"Bradley Hand" size:16.f],
                               NSForegroundColorAttributeName : [UIColor greenColor]};
    
    [self.clockList addObjectsFromArray:@[clock1, clock2]];
}

- (void)setupBigClock{
    CGFloat diameter = 300.f;
    CGFloat leftPadding = (CGRectGetWidth(self.view.frame) - diameter) / 2;
    //clock 1
    GKClock *clock1 = [[GKClock alloc] init];
    clock1.frame = CGRectMake(leftPadding, 290.f, diameter, diameter);
    [self.view addSubview:clock1];
    [clock1 start];
    
    clock1.clockBorderWidth = 2.f;
    clock1.clockBorderColor = [UIColor magentaColor];
    
    clock1.hourHandColor = [UIColor blueColor];
    clock1.hourHandWidth = 7.f,
    
    clock1.minuteHandColor = [UIColor greenColor];
    clock1.minuteHandWidth = 5.f;
    
    clock1.secondHandColor = [UIColor redColor];
    clock1.secondHandWidth = 3.f;
    
    clock1.centerPointColor = [UIColor purpleColor];
    clock1.centerPointRadius = 10.f;
    clock1.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"Noteworthy" size:30],
                               NSForegroundColorAttributeName : [UIColor yellowColor]};
    
    [self.clockList addObject:clock1];

}

- (void)switchButtongClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        for (GKClock *clock in self.clockList) {
            [clock stop];
        }
    }else{
        for (GKClock *clock in self.clockList) {
            [clock start];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
