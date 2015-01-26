//
//  SQLiteManager.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "RadioChannel.h"

@interface SQLiteManager : NSObject
+ (SQLiteManager *) getInstance;
- (NSMutableArray*)getChannels;
@end
