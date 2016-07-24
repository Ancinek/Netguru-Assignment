//
//  ContainerView.h
//  Netguru Assignment
//
//  Created by NYC on 22/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Bottom, Center, Top
} DisplayPosition;


@interface ContainerView : UIView

@property (nonatomic,strong) UIViewController* viewController;
@property (nonatomic, strong) UIView *contentView;
@property (assign) DisplayPosition slideToPosition;

// Constraints:
@property (nonatomic, strong) NSLayoutConstraint *initialYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *xConstraint;
@property (nonatomic, strong) NSLayoutConstraint *yConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (assign) CGFloat height;

// Functions:
- (void)initialSize:(UIViewController *)parentViewController;
- (void)initialSize:(UIViewController *)parentViewController
           withSize:(CGSize)size;
- (void)initialPosition:(DisplayPosition)initialPosition
   parentViewController:(UIViewController *)parentViewController;
- (void)show;
- (void)hide;
- (void)updatePosition;

- (void)displayContentController:(UIViewController*)content;
- (void)displayContentView:(UIView *)content;

- (void)constraintSetup:(UIView *)view;


@end
