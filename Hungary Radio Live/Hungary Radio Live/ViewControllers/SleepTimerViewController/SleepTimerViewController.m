//
//  SleepTimerViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 1/23/15.
//  Copyright (c) 2015 Thien Nguyen. All rights reserved.
//

#import "SleepTimerViewController.h"

@interface SleepTimerViewController ()

- (IBAction)actionClose:(id)sender;
@end

@implementation SleepTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
