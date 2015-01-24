//
//  SleepTimerViewController.h
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 1/23/15.
//  Copyright (c) 2015 Thien Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    NONE_TAG = 0,
    ITEM_15_TAG = 15*60,
    ITEM_30_TAG = 30*60,
    ITEM_60_TAG = 60*60,
    ITEM_90_TAG = 90*60
}ITEM_TAG;

typedef enum{
    TIMERING_STATUS,
    NONE_STATUS,
    STOPING_STATUS
}TIMER_STATUS;

@class SleepTimerViewController;

@protocol SleepTimerViewControllerDelegate <NSObject>
- (TIMER_STATUS)currentStatusTimer:(SleepTimerViewController*)sleepTimerVC;
- (NSString*)updateTextShowTimer:(SleepTimerViewController*)sleepTimerVC;
- (void)startSleepTimer:(SleepTimerViewController*)sleepTimerVC withTimer:(ITEM_TAG)totalTimer;
- (void)cancelSleepTimer:(SleepTimerViewController*)sleepTimerVC;
- (int)totalTimer:(SleepTimerViewController*)sleepTimerVC;
@end
@interface SleepTimerViewController : UIViewController
@property (nonatomic, assign) id<SleepTimerViewControllerDelegate> delegate;
@end
