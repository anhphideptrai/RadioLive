//
//  SQLiteManager.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SQLiteManager.h"
#define DB_NAME_STRING @"HungaryRadioLive.sqlite"
@interface SQLiteManager()

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

@end

@implementation SQLiteManager
static SQLiteManager *thisInstance;
+ (SQLiteManager *) getInstance{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        thisInstance = [[SQLiteManager alloc] init];
    }
    return thisInstance;
}
- (void)copyDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    _databasePath = [documentsDirectory stringByAppendingPathComponent:DB_NAME_STRING];
    
    if ([fileManager fileExistsAtPath:_databasePath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:DB_NAME_STRING ofType:@""];
        [fileManager copyItemAtPath:resourcePath toPath:_databasePath error:&error];
    }
}
- (NSMutableArray*)getChannels{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    RadioChannel *channel;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"select * from channel";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                channel = [[RadioChannel alloc] init];
                channel.pkey = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                channel.pic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                channel.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                channel.local_pic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
                channel.url = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                channel.country = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)];
                channel.isFavorite = sqlite3_column_int(statement, 6);
                [resultArray addObject:channel];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    return resultArray;
}
@end
