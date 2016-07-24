//
//  ContainerView.m
//  Netguru Assignment
//
//  Created by NYC on 22/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

@synthesize viewController;
@synthesize contentView;
@synthesize slideToPosition;
@synthesize initialYConstraint;
@synthesize yConstraint;
@synthesize xConstraint;
@synthesize heightConstraint;
@synthesize widthConstraint;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints: false];
    }
    return self;
}
- (void)initialSize:(UIViewController *)parentViewController {
    CGRect frame = self.frame;
    // Set frame:
    frame.origin.x = -500;
    frame.origin.y = -500;
    self.frame = frame;
    // Add as subview:
    [parentViewController.view addSubview: self];

    [self setBackgroundColor: [UIColor blackColor]];
}

- (void)constraintSetup:(UIView *)view {
    self.frame = view.frame;
    widthConstraint = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: view.frame.size.width];
    widthConstraint.active = true;
    heightConstraint = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: view.frame.size.height];
    heightConstraint.active = true;
}

- (void)initialPosition:(DisplayPosition)initialPosition
   parentViewController:(UIViewController *)parentViewController {
    
    [parentViewController.view addSubview: self];
    
    xConstraint = [NSLayoutConstraint constraintWithItem: self attribute:NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    CGFloat viewHeight = self.frame.size.height;
    
    switch (initialPosition) {
        case Bottom:
        {
            yConstraint = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeBottom multiplier:1.0 constant: viewHeight];
            slideToPosition = Bottom;
            break;
        }
        case Center:
        {
            yConstraint = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeTop multiplier:1.0 constant: -viewHeight];
            slideToPosition = Center;
            break;
        }
        case Top:
        {
            yConstraint = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:[self superview] attribute:NSLayoutAttributeTop multiplier:1.0 constant: -viewHeight];
            slideToPosition = Top;
            break;
        }
        default:
            break;
    }
    initialYConstraint = yConstraint;
    xConstraint.active = true;
    yConstraint.active = true;
    [[self superview] layoutIfNeeded];
    NSLog(@"Constraints in initialPosition are OK");
}

- (void) displayContentView: (UIView *)content {
    // Set content frame origin:
    CGRect contentFrame = self.frame;
    contentFrame.origin = CGPointMake(0.0, 0.0);
    content.frame = contentFrame;
    [self addSubview: content];
    contentView = content;
}

- (void)show {
    yConstraint.active = false;
    NSLayoutAttribute attribute;
    CGFloat constant;
    switch (slideToPosition) {
        case Top:
        {
            attribute = NSLayoutAttributeTop;
            constant = 5;
            break;
        }
        case Center:
        {
            attribute = NSLayoutAttributeCenterY;
            constant = 0;
            break;
        }
        case Bottom:
        {
            attribute = NSLayoutAttributeBottom;
            constant = -5;
            break;
        }
        default:
            break;
    }
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem: self attribute: attribute relatedBy: NSLayoutRelationEqual toItem:[self superview] attribute: attribute multiplier:1.0 constant: constant];
    yConstraint = newConstraint;
    yConstraint.active = true;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self superview] layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         // Possible future use...
                     }];
}
- (void)hide {
    yConstraint.active = false;
    yConstraint = initialYConstraint;
    yConstraint.active = true;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [[self superview] layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}



- (void) displayContentController: (UIViewController*) content {
    [viewController addChildViewController:content];
    content.view.frame = self.frame;
    [viewController.view addSubview: content.view];
    [content didMoveToParentViewController: viewController];
}




@end
