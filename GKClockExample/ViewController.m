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
@property (nonatomic, strong) GKClock *clock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.clock = [[GKClock alloc] init];
    self.clock.frame = CGRectMake(10.f, 0.f, self.view.frame.size.width - 20.f, self.view.frame.size.height - 100.f);
    [self.view addSubview:self.clock];
    [self.clock start];
    
    //自定义样式
    self.clock.layer.borderColor = [UIColor yellowColor].CGColor;
    self.clock.minuteHandColor = [UIColor yellowColor];
    self.clock.hourHandColor = [UIColor yellowColor];
    self.clock.secondHandColor = [UIColor yellowColor];
    self.clock.clockBorderColor = [UIColor yellowColor];
    self.clock.centerPointColor = [UIColor yellowColor];
    self.clock.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:35],
                                   NSForegroundColorAttributeName : [UIColor yellowColor]};
    
    
    UIButton *switchButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.layer.borderWidth = 1.f;
    switchButton.layer.borderColor = [UIColor yellowColor].CGColor;
    switchButton.frame = CGRectMake(10.f, CGRectGetMaxY(self.clock.frame) + 10.f, self.view.frame.size.width - 20.f, 40.f);
    [switchButton addTarget:self action:@selector(switchButtongClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setTitle:@"Start" forState:UIControlStateNormal];
    [switchButton setTitle:@"Stop" forState:UIControlStateSelected];
    [switchButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//    [self.view addSubview:switchButton];
}

- (void)switchButtongClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [self.clock stop];
    }else{
        [self.clock start];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
