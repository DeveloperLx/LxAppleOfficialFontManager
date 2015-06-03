//
//  LxAppleOfficialFontManager.m
//  LxAppleOfficialFontManager
//

#import "LxAppleOfficialFontManager.h"
#import <CoreText/CoreText.h>


static CGFloat const DEFAULT_FONT_SIZE = 12;

@implementation LxAppleOfficialFontManager

+ (BOOL)existsFontNamed:(NSString *)fontName
{
    NSCAssert([fontName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0, @"LxAppleOfficialFontManager: Parameter fontName cannot be empty!");
    
    UIFont * font = [UIFont fontWithName:fontName size:DEFAULT_FONT_SIZE];
    return font && ([font.fontName isEqualToString:fontName] || [font.familyName isEqualToString:fontName]);
}

+ (NSArray *)downloadableAvailableFontDescriptors
{
    NSDictionary * attributes = @{(id)kCTFontDownloadableAttribute:@YES};
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
    CFArrayRef fontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(descriptor, 0);
    return (__bridge NSArray *)fontDescriptors;
}

+ (void)downloadFontNamed:(NSString *)fontName
                 progress:(void (^)(CGFloat progress))progress
                 finished:(void (^)(UIFont * font))finished
                   failed:(void (^)(NSError * error))failed
{
    NSCAssert([fontName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0, @"LxAppleOfficialFontManager: Parameter fontName cannot be empty!");
    
    if ([self existsFontNamed:fontName]) {
        NSLog(@"LxAppleOfficialFontManager: Font %@ is already exists!", fontName);
        finished([UIFont fontWithName:fontName size:DEFAULT_FONT_SIZE]);
    }
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{(NSString *)kCTFontAttributeName:fontName});
    NSArray * fontDescriptors = @[(__bridge id)fontDescriptor];
    CFRelease(fontDescriptor);
    
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
                finished([UIFont fontWithName:fontName size:DEFAULT_FONT_SIZE]);
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
                progress((CGFloat)progressPercentage);
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
                failed(error);
            }
                break;
            default:
                break;
        }
        
        return true;
    });
}

@end
