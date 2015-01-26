//
//  ChannelsViewController.h
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioChannel.h"
@protocol ChannelsViewControllerDelegate <NSObject>
@optional
- (void) didSelectedChannel:(RadioChannel*)channel;
@end
@interface ChannelsViewController : UIViewController
@property (nonatomic, strong) id<ChannelsViewControllerDelegate> delegate;
@end
