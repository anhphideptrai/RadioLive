//
//  MainViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import "MainViewController.h"
#import <STKAudioPlayer.h>
#import "SampleQueueId.h"
#import <SCSiriWaveformView.h>
#import <MarqueeLabel.h>
@interface MainViewController ()<STKAudioPlayerDelegate>{
    NSTimer* timer;
}
@property (strong, nonatomic) IBOutlet UIButton *btChannel;
@property (strong, nonatomic) IBOutlet UISlider *sldVolume;
@property (strong, nonatomic) IBOutlet UIButton *btPlayOrPause;
@property (strong, nonatomic) IBOutlet UIButton *btPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btNext;
@property (strong, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;
@property (strong, nonatomic) IBOutlet MarqueeLabel *lbChannelInfo;
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;

- (IBAction)actionClickBTChannel:(id)sender;
- (IBAction)actionChangedVolume:(id)sender;
- (IBAction)actionClickBTPlayOrPause:(id)sender;
- (IBAction)actionBTPrevious:(id)sender;
- (IBAction)actionBTNext:(id)sender;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self indexFromPixels:[SlideNavigationController sharedInstance].portraitSlideOffset];
    [_waveFormView setWaveColor:_orange_color_];
    [_waveFormView setPrimaryWaveLineWidth:1.f];
    [_waveFormView setSecondaryWaveLineWidth:.5f];
    [_waveFormView setFrequency:10.f];
    
    
    
    _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    _audioPlayer.meteringEnabled = YES;
    _audioPlayer.volume = .5f;
    [_sldVolume setValue:.5f];
    _audioPlayer.delegate = self;
    
    NSURL* url = [NSURL URLWithString:@"http://vprbbc.streamguys.net/vprbbc24-nopreroll"];
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    [_audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
    [self setupTimer];
    [self updateControls];
    
    _lbChannelInfo.marqueeType = MLContinuous;
    _lbChannelInfo.scrollDuration = 10.0f;
    _lbChannelInfo.fadeLength = 10.0f;
    _lbChannelInfo.trailingBuffer = 30.0f;
    _lbChannelInfo.textColor = _orange_color_;
    _lbChannelInfo.text = @"Thien Nguyen - Hungary Radio Live                      Thien Nguyen - Hungary Radio Live                      ";
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                if (_audioPlayer) {
                    [_audioPlayer resume];
                }
                break;
                
            case  UIEventSubtypeRemoteControlPause:
                // pause the video
                if (_audioPlayer) {
                    [_audioPlayer pause];
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
#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
#pragma mark - Helpers -

- (NSInteger)indexFromPixels:(NSInteger)pixels
{
    if (pixels == 60)
        return 0;
    else if (pixels == 120)
        return 1;
    else
        return 2;
}

- (NSInteger)pixelsFromIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            return 60;
            
        case 1:
            return 120;
            
        case 2:
            return 200;
            
        default:
            return 0;
    }
}
- (IBAction)actionClickBTChannel:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:^{}];
}

- (IBAction)actionChangedVolume:(id)sender {
    if (_audioPlayer) {
        _audioPlayer.volume = _sldVolume.value;
    }
}

- (IBAction)actionClickBTPlayOrPause:(id)sender {
    if (!_audioPlayer)
    {
        return;
    }
    
    if (_audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PauseControl" ofType:@"png"]] forState:UIControlStateNormal];
        [_audioPlayer resume];
        
    }
    else
    {
        [_audioPlayer pause];
    }
}

- (IBAction)actionBTPrevious:(id)sender {
}

- (IBAction)actionBTNext:(id)sender {
}
-(void) setupTimer
{
    timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void) updateControls
{
    if (_audioPlayer == nil)
    {
        [_btPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayControl" ofType:@"png"]] forState:UIControlStateNormal];
    }else if (_audioPlayer.state == STKAudioPlayerStatePlaying)
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
    if (!_audioPlayer)
    {
        return;
    }
    
    if (_audioPlayer.currentlyPlayingQueueItemId == nil)
    {

        
        return;
    }
    CGFloat level = _audioPlayer.state == STKAudioPlayerStatePlaying ? pow(10, ([_audioPlayer averagePowerInDecibelsForChannel:1])/60 ): 0;
    [_waveFormView updateWithLevel:level];
}

#pragma mark - STKAudioPlayerDelegate Methods -
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
[self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
[self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
[self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
[self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
[self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
}
@end
