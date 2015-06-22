//
//  LxAppleOfficialFontManager.h
//  LxAppleOfficialFontManager
//

#import <UIKit/UIKit.h>


@interface LxAppleOfficialFontManager : NSObject

+ (BOOL)existsFontNamed:(NSString *)fontName;
+ (NSArray *)availableAppleFontDescriptors;
+ (void)downloadFontNamed:(NSString *)fontName
                 progress:(void (^)(CGFloat progress))progress
                 finished:(void (^)(UIFont * font))finished
                   failed:(void (^)(NSError * error))failed;

@end
