//
//  ConfigApp.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/14/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "ConfigApp.h"
@implementation ConfigApp
- (id)init{
    self = [super init];
    if (self) {
        self.statusApp = @"";
        self.urlShare = @"";
        self.version = @"";
        self.expriredDay = @"";
    }
    return self;
}
- (void)parser:(id)json{
    if (json == nil) return;
    self.statusApp = [json valueForKey:key_status_app];
    self.urlShare = [json valueForKey:key_url_share];
    self.version = [json valueForKey:key_version];
    self.expriredDay = [json valueForKey:key_expired_day];
    self.versionUpdate = [json valueForKey:key_version_update];
    self.iDchannelDefault = [json valueForKey:key_id_channel_default];
    self.urlUpdate = [json valueForKey:key_url_update];
}
@end
