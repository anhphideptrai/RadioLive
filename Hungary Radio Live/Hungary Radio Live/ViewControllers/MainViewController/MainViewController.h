//
//  MainViewController.h
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonView.h"
#import "ASOBounceButtonViewDelegate.h"
#import "AnimationMenuCustom.h"
@interface MainViewController : UIViewController <SlideNavigationControllerDelegate, ASOBounceButtonViewDelegate>
@property (strong, nonatomic) IBOutlet ASOTwoStateButton *menuButton;
@property (strong, nonatomic) AnimationMenuCustom *menuItemView;
@end
