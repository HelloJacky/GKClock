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
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.clock = [[GKClock alloc] init];
    self.clock.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
    self.clock.minuteHandColor = [UIColor greenColor];
    self.clock.hourHandColor = [UIColor blueColor];
    [self.view addSubview:self.clock];
    [self.clock start];
    
    UIButton *switchButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.layer.borderWidth = 1.f;
    switchButton.frame = CGRectMake(10.f, CGRectGetMaxY(self.clock.frame) + 10.f, self.view.frame.size.width - 20.f, 40.f);
    [switchButton addTarget:self action:@selector(switchButtongClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setTitle:@"Start" forState:UIControlStateNormal];
    [switchButton setTitle:@"Stop" forState:UIControlStateSelected];
    [self.view addSubview:switchButton];
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
