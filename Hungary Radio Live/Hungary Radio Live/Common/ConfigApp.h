//
//  ConfigApp.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/14/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface ConfigApp : NSObject
@property(nonatomic, strong) NSString *statusApp;
@property(nonatomic, strong) NSString *urlShare;
@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSString *expriredDay;
@property(nonatomic, strong) NSString *iDchannelDefault;
@property(nonatomic, strong) NSString *versionUpdate;
@property(nonatomic, strong) NSString *urlUpdate;
- (id)init;
- (void)parser:(id)json;
@end
