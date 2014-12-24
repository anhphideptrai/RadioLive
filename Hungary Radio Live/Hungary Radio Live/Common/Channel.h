//
//  Channel.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 12/25/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *stationURL;
@property (nonatomic, strong) NSString *stationLocation;
@property (nonatomic, strong) NSString *stationContent;
@property (nonatomic, strong) NSString *streamFormat;
@property (nonatomic, strong) NSString *streamFileURL;
@property (nonatomic, strong) NSString *streamFileContent;
@property (nonatomic, strong) NSString *bitRate;
@end
