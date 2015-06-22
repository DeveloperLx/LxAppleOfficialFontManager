//
//  LxAppleOfficialFontManager.m
//  LxAppleOfficialFontManager
//

#import "LxAppleOfficialFontManager.h"
#import <CoreText/CoreText.h>


static CGFloat const DEFAULT_FONT_SIZE = 20;

@implementation LxAppleOfficialFontManager

+ (BOOL)existsFontNamed:(NSString *)fontName
{
    NSCAssert([fontName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0, @"LxAppleOfficialFontManager: Parameter fontName cannot be empty!");
    
    UIFont * font = [UIFont fontWithName:fontName size:DEFAULT_FONT_SIZE];
    return font && ([font.fontName isEqualToString:fontName] || [font.familyName isEqualToString:fontName]);
}

+ (NSArray *)availableAppleFontDescriptors
{
    NSDictionary * fontDownloadableAttribute = @{(id)kCTFontDownloadableAttribute:@YES};
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontDownloadableAttribute);
    CFArrayRef fontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(fontDescriptor, 0);
    return (__bridge NSArray *)fontDescriptors;
}

+ (void)downloadFontNamed:(NSString *)fontName
                 progress:(void (^)(CGFloat progress))progress
                 finished:(void (^)(UIFont * font))finished
                   failed:(void (^)(NSError * error))failed
{
    NSCAssert([fontName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0, @"LxAppleOfficialFontManager: Parameter fontName cannot be empty!");
    
    UIFontDescriptor * fontDescriptor = [UIFontDescriptor fontDescriptorWithName:fontName size:DEFAULT_FONT_SIZE];
    NSArray * fontDescriptors = @[fontDescriptor];
    
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)fontDescriptors, 0, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        switch (state) {
            case kCTFontDescriptorMatchingDidBegin:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ matching begin!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingDidFinish:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ matching finished!", fontName);
                
                NSDictionary * progressParameterDict = (__bridge NSDictionary *)progressParameter;
                NSArray * fontDescriptorMatchingResultArray = progressParameterDict[(id)kCTFontDescriptorMatchingResult];
                UIFontDescriptor * fontDescriptor = fontDescriptorMatchingResultArray.firstObject;
                NSString * downloadedFontName = fontDescriptor.fontAttributes[UIFontDescriptorNameAttribute];
                if (finished) {
                    finished([UIFont fontWithName:downloadedFontName size:DEFAULT_FONT_SIZE]);
                }                
            }
                break;
            case kCTFontDescriptorMatchingWillBeginQuerying:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ querying begin!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingStalled:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ matching stalled!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingWillBeginDownloading:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ will begin to be downloaded!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingDownloading:
            {
                double progressPercentage = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
                
                NSLog(@"LxAppleOfficialFontManager: Font %@ matching is being download with progress %.2f%%!", fontName, progressPercentage);
                if (progress) {
                    progress((CGFloat)progressPercentage);
                }
            }
                break;
            case kCTFontDescriptorMatchingDidFinishDownloading:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ did downloaded!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingDidMatch:
            {
                NSLog(@"LxAppleOfficialFontManager: Font %@ matched!", fontName);
            }
                break;
            case kCTFontDescriptorMatchingDidFailWithError:
            {
                NSError * error = [(__bridge NSDictionary *)progressParameter valueForKey:(id)kCTFontDescriptorMatchingError];
                NSLog(@"LxAppleOfficialFontManager: Font %@ download failed because of %@!", fontName, error);
                if (failed) {
                    failed(error);
                }
            }
                break;
            default:
                break;
        }
        
        return true;
    });
}

@end
