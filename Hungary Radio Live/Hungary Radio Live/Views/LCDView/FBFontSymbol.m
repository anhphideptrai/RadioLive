#import "FBFontSymbol.h"

@implementation FBFontSymbol

static NSMutableArray *symbols;

+ (NSArray *)symbolsForString:(NSString *)str
{
    //@[].mutableCopy is causing memory leaks because new arrays are getting created everytime it's refreshed.
    //Only create symbols if it's nil, else remove all symbols and keep reusing the NSMutableArray.
    if (symbols == nil) {
        symbols = @[].mutableCopy;
    } else {
        [symbols removeAllObjects];
    }
    
    NSString *upper = [str uppercaseString];
    for (NSInteger i = 0; i < upper.length; i++) {
        NSString *c = [upper substringWithRange:NSMakeRange(i,1)];
        if ([c isEqualToString:@"0"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol0]];
        } else if ([c isEqualToString:@"1"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol1]];
        } else if ([c isEqualToString:@"2"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol2]];
        } else if ([c isEqualToString:@"3"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol3]];
        } else if ([c isEqualToString:@"4"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol4]];
        } else if ([c isEqualToString:@"5"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol5]];
        } else if ([c isEqualToString:@"6"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol6]];
        } else if ([c isEqualToString:@"7"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol7]];
        } else if ([c isEqualToString:@"8"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol8]];
        } else if ([c isEqualToString:@"9"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbol9]];
        }  else if ([c isEqualToString:@":"]) {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbolColon]];
        } else {
            [symbols addObject:[NSNumber numberWithInt:FBFontSymbolSpace]];
        }
    }
    return symbols;
}

@end
