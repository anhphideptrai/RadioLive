#import <Foundation/Foundation.h>

typedef enum {
  FBFontSymbol0 = 0,
  FBFontSymbol1,
  FBFontSymbol2,
  FBFontSymbol3,
  FBFontSymbol4,
  FBFontSymbol5,
  FBFontSymbol6,
  FBFontSymbol7,
  FBFontSymbol8,
  FBFontSymbol9,
  FBFontSymbolColon,
  FBFontSymbolSpace
} FBFontSymbolType;

@interface FBFontSymbol : NSObject
+ (NSArray *)symbolsForString:(NSString *)str;
@end
