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
    self.clock = [[GKClock alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.clock];
    [self.clock start];
    
    
    UIButton *switchButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.layer.borderWidth = 1.f;
    switchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    switchButton.frame = CGRectMake(10.f, CGRectGetMaxY(self.view.frame) - 50.f, self.view.frame.size.width - 20.f, 40.f);
    [switchButton addTarget:self action:@selector(switchButtongClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setTitle:@"Stop" forState:UIControlStateNormal];
    [switchButton setTitle:@"Start" forState:UIControlStateSelected];
    [switchButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

@end
