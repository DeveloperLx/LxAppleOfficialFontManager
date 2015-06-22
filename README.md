#	LxAppleOfficialFontManager

######	Fetch graceful font from apple official handily!
---
###	Installation
	You only need drag LxKeychain.h and LxKeychain.m to your project.
###	Support	
	Minimum support iOS version: iOS 7.0
###	Usage
	NSArray * downloadableAvailableFontDescriptors = [LxAppleOfficialFontManager availableAppleFontDescriptors];
    
    UIFontDescriptor * randomFontDescriptor = downloadableAvailableFontDescriptors[arc4random()%downloadableAvailableFontDescriptors.count];
    
    NSString * randomFontName = randomFontDescriptor.fontAttributes[UIFontDescriptorNameAttribute];
    
    [LxAppleOfficialFontManager
     downloadFontNamed:randomFontName
     progress:^(CGFloat progress) {
        
         NSLog(@"progress = %f", progress); //
         dispatch_async(dispatch_get_main_queue(), ^{
            
             _label.text = [NSString stringWithFormat:@"%.2f%% downloaded", progress];
         });
     }
     finished:^(UIFont *font) {
         
         NSLog(@"font = %@", font); //
         dispatch_async(dispatch_get_main_queue(), ^{
             
             _label.text = [NSString stringWithFormat:@"This is apple offical font %@!", font.fontName];
             _label.font = font;
         });
     }
     failed:^(NSError *error) {
        
         NSLog(@"error = %@", error);   //
     }];
---
###	License
LxLabel is available under the Apache License 2.0. See the LICENSE file for more info.
