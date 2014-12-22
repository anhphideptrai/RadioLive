//
//  Constants.h
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/19/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#ifndef Hungary_Radio_Live_Constants_h
#define Hungary_Radio_Live_Constants_h
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MAIN_XIB_FILE_NAME (IS_IPAD ? @"iPad_MainViewController" : @"iPhone_MainViewController")
#define CHANNELS_XIB_FILE_NAME (IS_IPAD ? @"iPad_ChannelsViewController" : @"iPhone_ChannelsViewController")

#define _red_color_         [UIColor colorWithRed:1.0 green:65.0/255 blue:54.0/255 alpha:1.0]
#define _green_color_       [UIColor colorWithRed:46.0/255 green:204.0/255 blue:64.0/255 alpha:1.0]
#define _blue_color_        [UIColor colorWithRed:0 green:116.0/255 blue:217.0/255 alpha:1.0]
//#define _orange_color_      [UIColor colorWithRed:1.0 green:133.0/255 blue:27.0/255 alpha:1.0]
#define _grayButton_color_  [UIColor darkGrayColor]
#define _orange_color_      [UIColor colorWithRed:253.f/255.f green:145.f/255.f blue:29.f/255.f alpha:1.0]
#endif
