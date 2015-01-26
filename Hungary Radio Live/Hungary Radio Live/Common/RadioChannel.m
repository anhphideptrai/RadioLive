//
//  RadioChannel.m
//  HTMLParsing
//
//  Created by Phi Nguyen on 1/26/15.
//  Copyright (c) 2015 Swipe Stack Ltd. All rights reserved.
//

#import "RadioChannel.h"

@implementation RadioChannel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.pkey = @"";
        self.pic = @"";
        self.title = @"";
        self.local_pic = @"";
        self.url = @"";
        self.isFavorite = false;
        self.country = @"";
    }
    return self;
}
- (void)parser:(id)obj{
    if (obj == nil) return;
    self.pkey = [obj objectForKey:@"pkey"];
    self.pic = [obj objectForKey:@"pic"];
    self.title = [obj objectForKey:@"title"];
    self.local_pic = [obj objectForKey:@"local_pic"];
    self.url = [obj objectForKey:@"url"];
    self.country = [obj objectForKey:@"country"];}
@end
