//
//  Utils.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/19/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (NSString*) getTimeFrom:(NSDate*) date withFormat:(NSString*) format{
    if (date!=nil && !([format isEqualToString:@"hh:mm a"]||[format isEqualToString:@"hh:mm"])) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:format];
        return  [timeFormat stringFromDate:date];
    }
    else if (date!=nil && ([format isEqualToString:@"hh:mm a"]||[format isEqualToString:@"hh:mm"])){
        BOOL havePMorAM = [format isEqualToString:@"hh:mm a"];
        NSString *_pm = havePMorAM?@" pm":@"";
        NSString *_am = havePMorAM?@" am":@"";
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSInteger showHour = hour%12;
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld%@", havePMorAM?(showHour == 0 ? 12: showHour):hour, (long)minute, (int)(hour/12) > 0?_pm:_am];
    }
    else {
        return nil;
    }
}
+(NSString*)time {
    //do smth
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSDate *date = [[NSDate alloc]init];
    
    return [dateFormatter stringFromDate:date];
}
@end
