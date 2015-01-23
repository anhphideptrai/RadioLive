//
//  SleepTimerViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 1/23/15.
//  Copyright (c) 2015 Thien Nguyen. All rights reserved.
//

#import "SleepTimerViewController.h"

@interface SleepTimerViewController ()
@property (strong, nonatomic) IBOutlet UIView *centerView;

- (IBAction)actionClose:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btControl;
@property (strong, nonatomic) IBOutlet UIButton *btClose;
@end

@implementation SleepTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self.btClose setTitleColor:_orange_color_ forState:UIControlStateNormal];
    
    [self.btControl.layer setCornerRadius:(IS_IPAD?85.f:65.f)];
    [self.btControl.layer setMasksToBounds:YES];
    [self.btControl.layer setBorderWidth:1.0f];
    [self.btControl.layer setBorderColor:[[UIColor whiteColor] CGColor]];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
