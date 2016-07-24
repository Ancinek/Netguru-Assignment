//
//  UIViewController+StatusCategory.m
//  Netguru Assignment
//
//  Created by NYC on 23/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "UIViewController+StatusCategory.h"

@implementation UIViewController (StatusCategory)

- (StatusView *)displayStatusViewWithMessage:(NSString *)statusMessage
                   currentStatusView:(StatusView *)currentStatusView
                             loading:(BOOL)loading
                               error:(BOOL)error
                          completion:(void (^)(void))completion

{
    // Add status view below the view:
    StatusView *statusView = [[[NSBundle mainBundle] loadNibNamed: @"StatusView" owner: self options:nil] objectAtIndex: 0];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = 50.0;
    CGRect initialFrame = CGRectMake(0.0, self.view.frame.size.height, width, height);
    statusView.frame = initialFrame;
    [self.view addSubview: statusView];
    // Setup color:
    UIColor *blueColor = [UIColor customColorWithRed: 33.0 green:150.0 blue:243.0 alpha:1.0];
    UIColor *redColor = [UIColor customColorWithRed: 231.0 green:76.0 blue:60.0 alpha:1.0];
    statusView.backgroundColor = error ? redColor : blueColor;
    // Setup image:
    statusView.statusImageView.image = error ? [UIImage imageNamed: @"error"] : [UIImage imageNamed: @"whitewolf"];
    // Setup indicator:
    statusView.statusActivityIndicatorView.hidden = loading ? false : true;
    if (loading) {
        [statusView.statusActivityIndicatorView startAnimating];
    }
    // Setup outlets
    statusView.statusLabel.text = statusMessage;
    // Reveal:
    CGRect finalFrame = statusView.frame;
    finalFrame.origin.y -= height;
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         statusView.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         //currentStatusView = statusView;
                         completion();
                     }];
    return statusView;
}

- (void)hideStatusViewWithDelay:(CGFloat)delay
              currentStatusView:(StatusView *)currentStatusView
                     completion:(void (^)(void))completion
                      {
    CGRect hiddenFrame = currentStatusView.frame;
    hiddenFrame.origin.y += currentStatusView.frame.size.height;
    [UIView animateWithDuration: 0.3 delay: delay options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         currentStatusView.frame = hiddenFrame;
                     }
                     completion:^(BOOL finished) {
                         [currentStatusView removeFromSuperview];
                         //currentStatusView = nil;
                         if (completion != nil) {
                             completion();
                         }
                     }];
}

- (void)gradientStart:(UIColor *)firstColor
                  end:(UIColor *)secondColor {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor], (id)[secondColor CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end

@implementation UITextField (TextfieldCategory)

- (void)textfieldWithBottomBorderWidth:(CGFloat)width
                                 color:(UIColor *)color {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = width;
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

- (void)placeholderColor:(UIColor *)color
                withText:(NSString *)text {
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString: text attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

@end

@implementation UINavigationBar (NavigationBarCategory)

- (void)barWithGradient:(UIColor *)firstColor
            secondColor:(UIColor *)secondColor {
    // Create gradient:
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor], (id)[secondColor CGColor], nil];
    // Grab its image:
    UIGraphicsBeginImageContext(gradient.bounds.size);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Set the image as navigation bar background:
    [self setBackgroundImage: gradientImage forBarMetrics: UIBarMetricsDefault];
}

@end

@implementation UIColor (ColorCategory)

+ (UIColor *)customColorWithRed:(CGFloat)red
                     green:(CGFloat)green
                      blue:(CGFloat)blue
                     alpha:(CGFloat)alpha {
    return [UIColor colorWithRed: red/255.0 green: green/255.0 blue: blue/255.0 alpha: alpha];
}
+ (UIColor *)colorWithHEX:(NSString *)hex {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString: hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
