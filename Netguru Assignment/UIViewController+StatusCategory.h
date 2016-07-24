//
//  UIViewController+StatusCategory.h
//  Netguru Assignment
//
//  Created by NYC on 23/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusView.h"

@interface UIViewController (StatusCategory)

- (StatusView *)displayStatusViewWithMessage:(NSString *)statusMessage
                   currentStatusView:(StatusView *)currentStatusView
                             loading:(BOOL)loading
                               error:(BOOL)error
                          completion:(void (^)(void))completion;
- (void)hideStatusViewWithDelay:(CGFloat)delay
              currentStatusView:(StatusView *)currentStatusView
                     completion:(void(^)(void))completion;

- (void)gradientStart:(UIColor *)firstColor
                  end:(UIColor *)secondColor;


@end


@interface UITextField (TextfieldCategory)

- (void)textfieldWithBottomBorderWidth:(CGFloat)width
                                 color:(UIColor *)color;
- (void)placeholderColor:(UIColor *)color
                withText:(NSString *)text;

@end

@interface UINavigationBar (NavigationBarCategory)

- (void)barWithGradient:(UIColor *)firstColor
            secondColor:(UIColor *)secondColor;

@end

@interface  UIColor (ColorCategory)

+ (UIColor *)customColorWithRed:(CGFloat)red
                     green:(CGFloat)green
                      blue:(CGFloat)blue
                          alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHEX:(NSString *)hex;
@end
