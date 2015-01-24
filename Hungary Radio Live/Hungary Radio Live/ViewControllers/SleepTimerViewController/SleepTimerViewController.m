//
//  SleepTimerViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 1/23/15.
//  Copyright (c) 2015 Thien Nguyen. All rights reserved.
//

#import "SleepTimerViewController.h"
#import "FBLCDFontView.h"

@interface SleepTimerViewController (){
    ITEM_TAG currentSelected;
    TIMER_STATUS currentStatus;
    NSTimer *timerUpdate;
}
@property (strong, nonatomic) IBOutlet UIView *centerView;

- (IBAction)actionClose:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btControl;
@property (strong, nonatomic) IBOutlet UIButton *btClose;
@property (strong, nonatomic) IBOutlet UIImageView *imgNone;
@property (strong, nonatomic) IBOutlet UIImageView *img15;
@property (strong, nonatomic) IBOutlet UIImageView *img30;
@property (strong, nonatomic) IBOutlet UIImageView *img60;
@property (strong, nonatomic) IBOutlet UIImageView *img90;
@property (strong, nonatomic) IBOutlet UIButton *btnNone;
@property (strong, nonatomic) IBOutlet UIButton *btn15;
@property (strong, nonatomic) IBOutlet UIButton *btn30;
@property (strong, nonatomic) IBOutlet UIButton *btn60;
@property (strong, nonatomic) IBOutlet UIButton *btn90;
@property (strong, nonatomic) IBOutlet UIView *showTimerView;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalTimer;
- (IBAction)actionItemClick:(id)sender;
- (IBAction)actionControl:(id)sender;
@property (strong, nonatomic) IBOutlet FBLCDFontView *lCDView;
@end

@implementation SleepTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.btClose setTitleColor:_orange_color_ forState:UIControlStateNormal];
    [self.btControl.layer setCornerRadius:(IS_IPAD?85.f:65.f)];
    [self.btControl.layer setMasksToBounds:YES];
    [self.btControl.layer setBorderWidth:1.0f];
    [self.centerView setHidden:YES];
    [self.showTimerView setHidden:YES];
    if (self.delegate) {
        currentStatus = [self.delegate currentStatusTimer:self];
        [self setupTimer];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.delegate) {
        [self setupLCDFont];
    }
}
- (void)setupTimer{
    [self setupControl];
    [self setupContentView];
    if (timerUpdate) {
        [timerUpdate invalidate];
        timerUpdate = nil;
    }
    if (currentStatus == TIMERING_STATUS) {
        timerUpdate = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
}
- (void)tick{
    currentStatus = [self.delegate currentStatusTimer:self];
    if (currentStatus == TIMERING_STATUS) {
        self.lCDView.text = [self.delegate updateTextShowTimer:self];
    }else{
        currentSelected = NONE_TAG;
        [self setupTimer];
    }
    
}
- (void)setupControl{
    switch (currentStatus) {
        case NONE_STATUS:{
            [self.btControl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btControl setTitle:@"START" forState:UIControlStateNormal];
            [self.btControl setBackgroundColor:UIColorFromRGB(0x353A41)];
            [self.btControl.layer setBorderColor:[[UIColor grayColor] CGColor]];
            [self.btControl setEnabled:NO];
        }
            break;
        case TIMERING_STATUS:{
            [self.btControl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btControl setTitle:@"CANCEL" forState:UIControlStateNormal];
            [self.btControl setBackgroundColor:UIColorFromRGB(0x701E22)];
            [self.btControl.layer setBorderColor:[[UIColor redColor] CGColor]];
            [self.btControl setEnabled:YES];
        }
            break;
        case STOPING_STATUS:{
            [self.btControl setTitleColor:UIColorFromRGB(0x21AE52) forState:UIControlStateNormal];
            [self.btControl setTitle:@"START" forState:UIControlStateNormal];
            [self.btControl setBackgroundColor:UIColorFromRGB(0xE0E0E0)];
            [self.btControl.layer setBorderColor:[UIColorFromRGB(0x21AE52) CGColor]];
            [self.btControl setEnabled:YES];
        }
            break;
    }
}
- (void)setupContentView{
    if (currentStatus != TIMERING_STATUS) {
        [self.imgNone setHidden:self.imgNone.tag != currentSelected];
        [self.img15 setHidden:self.img15.tag != currentSelected];
        [self.img30 setHidden:self.img30.tag != currentSelected];
        [self.img60 setHidden:self.img60.tag != currentSelected];
        [self.img90 setHidden:self.img90.tag != currentSelected];
        [self.centerView setHidden:NO];
        [self.showTimerView setHidden:YES];
    }else{
        [self.lbTotalTimer setText:[NSString stringWithFormat:@"Total: %d minutes", [self.delegate totalTimer:self]]];
        [self.centerView setHidden:YES];
        [self.showTimerView setHidden:NO];
        [self setupLCDFont];
    }
}
- (void)setupLCDFont
{
    self.lCDView.text = [self.delegate updateTextShowTimer:self];
    self.lCDView.lineWidth = 8.0;
    self.lCDView.drawOffLine = YES;
    self.lCDView.edgeLength = 26;
    self.lCDView.margin = 10.0;
    self.lCDView.backgroundColor = [UIColor clearColor];
    self.lCDView.glowSize = 10.0;
    self.lCDView.glowColor = UIColorFromRGB(0x00ffff);
    self.lCDView.innerGlowColor = UIColorFromRGB(0x00ffff);
    self.lCDView.innerGlowSize = 3.0;
    [self.lCDView resetSize];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)actionItemClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    currentSelected = (ITEM_TAG)btn.tag;
    if (currentSelected == NONE_TAG) {
        currentStatus = NONE_STATUS;
    }else{
        currentStatus = STOPING_STATUS;
    }
    [self setupControl];
    [self setupContentView];
}

- (IBAction)actionControl:(id)sender {
    if (self.delegate) {
        if (currentStatus == STOPING_STATUS) {
            if ([self.delegate respondsToSelector:@selector(startSleepTimer:withTimer:)]) {
                [self.delegate startSleepTimer:self withTimer:currentSelected];
                currentStatus = TIMERING_STATUS;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(cancelSleepTimer:)]) {
                [self.delegate cancelSleepTimer:self];
                currentStatus = NONE_STATUS;
                currentSelected = NONE_TAG;
            }
        }
        [self setupTimer];
    }
}
@end
