//
//  OptionsView.h
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerView.h"
#import "MainOTVC.h"
#import "SortOTVC.h"

@protocol OptionsViewDelegate <NSObject>

- (void)cancelSelected;
- (void)favoriteSelected;
- (void)hotSelected;

@end

@interface OptionsView : UIView <MainOTVCDelegate, SortOTVCDelegate>

@property (nonatomic, strong) UITableViewController *currentEmbeddedTVC;
@property (nonatomic, weak) id<OptionsViewDelegate>delegate;


- (id)initWithSuperview:(UIView *)superview;
- (void)setupFrame:(UIView *)superview;
- (void)embedTableViewController:(UITableViewController *)tableViewController;



@end
