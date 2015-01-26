//
//  RadioChannel.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 1/26/15.
//  Copyright (c) 2015 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioChannel : NSObject
@property (nonatomic, strong) NSString *pkey;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *local_pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *country;
@property (nonatomic) BOOL isFavorite;
- (void)parser:(id)obj;
@end
