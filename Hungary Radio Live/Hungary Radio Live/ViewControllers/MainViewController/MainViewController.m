//
//  MainViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import "MainViewController.h"
#import "SampleQueueId.h"
#import <SCSiriWaveformView.h>
#import <MarqueeLabel.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SleepTimerViewController.h"
#import <ZGCountDownTimer.h>
#import "SQLiteManager.h"
#import "AppDelegate.h"
#import "AudioStreamer.h"

@interface MainViewController ()<SleepTimerViewControllerDelegate, ZGCountDownTimerDelegate>{
    NSTimer* timer;
    MPVolumeView *volumeView;
    ITEM_TAG totalTimer;
    TIMER_STATUS currentTimerStatus;
    ZGCountDownTimer *countDown;
    RadioChannel *currentChannel;
    AudioStreamer *audioStreamer;
}
@property (strong, nonatomic) IBOutlet UIButton *btChannel;
@property (strong, nonatomic) IBOutlet UIView *volumeFrame;
@property (strong, nonatomic) IBOutlet UIButton *btPlayOrPause;
@property (strong, nonatomic) IBOutlet UIButton *btPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btNext;
@property (strong, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;
@property (strong, nonatomic) IBOutlet MarqueeLabel *lbChannelInfo;
@property (nonatomic) ASOAnimationStyle progressiveORConcurrentStyle;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;

- (IBAction)actionClickBTChannel:(id)sender;
- (IBAction)actionClickBTPlayOrPause:(id)sender;
- (IBAction)actionBTPrevious:(id)sender;
- (IBAction)actionBTNext:(id)sender;
- (IBAction)actionFavorite:(id)sender;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [[SlideNavigationController sharedInstance] setPortraitSlideOffset:_MENU_DEFAULT_SLIDE_OFFSET_];
    
    [_waveFormView setWaveColor:_orange_color_];
    [_waveFormView setPrimaryWaveLineWidth:1.f];
    [_waveFormView setSecondaryWaveLineWidth:.5f];
    [_waveFormView setFrequency:3.f];
    
    [self setupTimer];
    [self updateControls];
    
    _lbChannelInfo.marqueeType = MLContinuous;
    _lbChannelInfo.scrollDuration = 10.0f;
    _lbChannelInfo.fadeLength = 50.0f;
    _lbChannelInfo.trailingBuffer = 30.0f;
    _lbChannelInfo.textColor = _orange_color_;
    _lbChannelInfo.text = @"Thien Nguyen - Hungary Radio Live                      Thien Nguyen - Hungary Radio Live                      ";
    
    [self.menuButton setOnStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton setOffStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton initAnimationWithFadeEffectEnabled:YES];
    self.menuItemView = [[[NSBundle mainBundle] loadNibNamed:NAME_XIB_ANIMATION_MENU_VIEW_CONTROLLER owner:self options:nil] lastObject];
    [self.menuItemView setBackgroundColor:[UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.5f]];
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects:self.menuItemView.menuItem1,
                                   self.menuItemView.menuItem2,
                                   nil]; // Add all of the defined 'menu item button' to 'menu item view'
    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.2f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    
    [self.menuItemView setAnimationStyle:ASOAnimationStyleRiseProgressively];
    self.progressiveORConcurrentStyle = ASOAnimationStyleRiseProgressively;
    
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
    [self setupCountDown];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    currentChannel = [[SQLiteManager getInstance] loadChannelWithID:appDelegate.config.iDchannelDefault];
    if (currentChannel) {
        NSString *text = [NSString stringWithFormat:@"%@ - %@ - %@", currentChannel.title, currentChannel.country, [NSString stringWithFormat:@"# %@", currentChannel.pkey]];
        _lbChannelInfo.text = [NSString stringWithFormat:@"%@                      %@                      ", text, text];
    }
}
- (void)setupCountDown{
    currentTimerStatus = NONE_STATUS;
    if (!countDown) {
        countDown = [ZGCountDownTimer countDownTimerWithIdentifier:nil];
        [countDown setDelegate:self];
        [countDown resetCountDown];
        [countDown setTotalCountDownTime:0];
        [countDown setupCountDownForTheFirstTime:^(ZGCountDownTimer *timer) {
        } restoreFromBackUp:^(ZGCountDownTimer *timer) {
        }];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self.menuItemView setAnimationStartFromHere:self.menuButton.frame];
    if (!volumeView) {
        volumeView = [[MPVolumeView alloc] initWithFrame:self.volumeFrame.bounds];
        [volumeView setMinimumVolumeSliderImage:[UIImage imageNamed:@"Cell_Selected.png"] forState:UIControlStateNormal];
        [self.volumeFrame addSubview:volumeView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ASStatusChangedNotification
                                                  object:nil];
}
- (void)playWithChannel:(RadioChannel*)channel{
    currentChannel = channel;
    NSURL* url = [NSURL URLWithString:channel.url];
    NSString *text = [NSString stringWithFormat:@"%@ - %@ - %@", channel.title, channel.country, [NSString stringWithFormat:@"# %@", channel.pkey]];
    _lbChannelInfo.text = [NSString stringWithFormat:@"%@                      %@                      ", text, text];
    if (audioStreamer) {
        [audioStreamer stop];
        audioStreamer = nil;
    }
    audioStreamer = [[AudioStreamer alloc] initWithURL:url];
    [audioStreamer start];
    
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                if (audioStreamer) {
                    [audioStreamer start];
                }
                break;
                
            case  UIEventSubtypeRemoteControlPause:
                // pause the video
                if (audioStreamer) {
                    [audioStreamer pause];
                }
                break;
                
            case  UIEventSubtypeRemoteControlNextTrack:
                [self actionBTNext:_btNext];
                break;
                
            case  UIEventSubtypeRemoteControlPreviousTrack:
                [self actionBTNext:_btPrevious];
                break;
                
            default:
                break;
        }
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)menuButtonAction:(id)sender
{
    if ([sender isOn]) {
        // Show 'menu item view' and expand its 'menu item button'
        [self.menuButton addCustomView:self.menuItemView];
        [self.menuItemView expandWithAnimationStyle:self.progressiveORConcurrentStyle];
    }
    else {
        // Collapse all 'menu item button' and remove 'menu item view'
        [self.menuItemView collapseWithAnimationStyle:self.progressiveORConcurrentStyle];
        [self.menuButton removeCustomView:self.menuItemView interval:[self.menuItemView.collapsedViewDuration doubleValue]];
    }
}
- (void)didSelectBounceButtonAtIndex:(NSUInteger)index
{
    [self.menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    if (index == 0) {
        SleepTimerViewController *sleepTimerVC = [[SleepTimerViewController alloc] initWithNibName:NAME_XIB_SLEEP_TIMER_VIEW_CONTROLLER bundle:nil];
        [sleepTimerVC setDelegate:self];
        [self presentViewController:sleepTimerVC animated:YES completion:^{
            
        }];
    }
}

- (IBAction)sendActionForMenuButton:(id)sender{
    [self.menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)actionClickBTChannel:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:^{}];
}

- (IBAction)actionClickBTPlayOrPause:(id)sender {
    if (!audioStreamer)
    {
        if (currentChannel) {
            audioStreamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:currentChannel.url]];
            [audioStreamer start];
        }
        return;
    }
    
    if (audioStreamer.state == AS_PAUSED)
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PauseControl" ofType:@"png"]] forState:UIControlStateNormal];
        [audioStreamer start];
        
    }else if (audioStreamer.state == AS_STOPPED){
        [self playWithChannel:currentChannel];
    }
    else
    {
        [audioStreamer pause];
    }
}

- (IBAction)actionBTPrevious:(id)sender {
}

- (IBAction)actionBTNext:(id)sender {
}
-(void) setupTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(tick) userInfo:nil repeats:YES];
}
-(void) updateControls
{
    if (audioStreamer == nil)
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayControl" ofType:@"png"]] forState:UIControlStateNormal];
    }else if (audioStreamer.state == AS_PLAYING)
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PauseControl" ofType:@"png"]] forState:UIControlStateNormal];;
    }
    else
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayControl" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
    [self tick];
}
-(void) tick
{
    if (!audioStreamer)
    {
        [_waveFormView updateWithLevel:0];
        return;
    }
    CGFloat level = audioStreamer.state == AS_PLAYING ? pow(10, ([audioStreamer averagePowerForChannel:1]) ): 0;
    [_waveFormView updateWithLevel:level];
}
- (void)playbackStateChanged:(NSNotification *)aNotification
{
    [self updateControls];
}
#pragma mark - ChannelsViewControllerDelegate Methods -
- (void) didSelectedChannel:(RadioChannel*)channel{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [self playWithChannel:channel];
    }];
}
#pragma mark - SleepTimerViewControllerDelegate Methods
- (TIMER_STATUS)currentStatusTimer:(SleepTimerViewController*)sleepTimerVC{
    return currentTimerStatus;
}
- (NSString*)updateTextShowTimer:(SleepTimerViewController*)sleepTimerVC{
    if (countDown) {
        NSTimeInterval remainTime = countDown.totalCountDownTime - countDown.timePassed;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", (int)remainTime/60/60, (int)remainTime/60%60, (int)remainTime%60];
        
    }else{
        return @"00:00:00";
    }
}
- (void)startSleepTimer:(SleepTimerViewController*)sleepTimerVC withTimer:(ITEM_TAG)totalT{
    totalTimer = totalT;
    if (countDown) {
        [countDown resetCountDown];
        [countDown setTotalCountDownTime:totalTimer*60];
        [countDown startCountDown];
    }
    currentTimerStatus = TIMERING_STATUS;
}
- (void)cancelSleepTimer:(SleepTimerViewController*)sleepTimerVC{
    if (countDown) {
        [countDown resetCountDown];
        [countDown setTotalCountDownTime:0];
    }
    currentTimerStatus = NONE_STATUS;
}
- (int)totalTimer:(SleepTimerViewController*)sleepTimerVC{
    return totalTimer;
}
#pragma mark - ZGCountDownTimerDelegate Methods
- (void)countDownCompleted:(ZGCountDownTimer *)sender{
    if (audioStreamer) {
        [audioStreamer stop];
    }
    [self cancelSleepTimer:nil];
}
- (IBAction)actionFavorite:(id)sender {
}
@end
