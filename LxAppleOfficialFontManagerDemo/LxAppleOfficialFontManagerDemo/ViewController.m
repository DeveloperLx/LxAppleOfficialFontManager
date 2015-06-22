//
//  ViewController.m
//  LxAppleOfficialFontManagerDemo
//

#import "ViewController.h"
#import "LxAppleOfficialFontManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    label.text = @"Preparing...";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.numberOfLines = 0;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    NSArray * downloadableAvailableFontDescriptors = [LxAppleOfficialFontManager availableAppleFontDescriptors];
    
    UIFontDescriptor * randomFontDescriptor = downloadableAvailableFontDescriptors[arc4random()%downloadableAvailableFontDescriptors.count];
    
    NSString * randomFontName = randomFontDescriptor.fontAttributes[UIFontDescriptorNameAttribute];
    
    [LxAppleOfficialFontManager
     downloadFontNamed:randomFontName
     progress:^(CGFloat progress) {
        
         NSLog(@"progress = %f", progress); //
         dispatch_async(dispatch_get_main_queue(), ^{
            
             label.text = [NSString stringWithFormat:@"%.2f%% downloaded", progress];
         });
     }
     finished:^(UIFont *font) {
         
         NSLog(@"font = %@", font); //
         dispatch_async(dispatch_get_main_queue(), ^{
             
             label.text = [NSString stringWithFormat:@"This is apple offical font %@!", font.fontName];
             label.font = font;
         });
     }
     failed:^(NSError *error) {
        
         NSLog(@"error = %@", error);   //
     }];
}

@end
