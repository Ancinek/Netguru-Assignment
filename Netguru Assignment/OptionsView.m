//
//  OptionsView.m
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "OptionsView.h"

@implementation OptionsView

@synthesize currentEmbeddedTVC;


- (id)initWithSuperview:(UIView *)superview {
    self = [super init];
    if (self) {
        [self setupFrame: superview];
        [self embedTableViewController: currentEmbeddedTVC];
    }
    return self;
}



- (void)setupFrame:(UIView *)superview {
    MainOTVC *mainOTVC = (MainOTVC *)[[UIStoryboard storyboardWithName: @"Options" bundle: nil] instantiateViewControllerWithIdentifier: @"MainOTVC"];
    mainOTVC.delegate = self;
    CGFloat width = superview.frame.size.width * 0.9;
    CGFloat height = mainOTVC.tableView.rowHeight * [mainOTVC.tableView numberOfRowsInSection: 0];
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGRect frame = CGRectMake(x, y, width, height);
    self.frame = frame;
    mainOTVC.view.frame = self.frame;
    currentEmbeddedTVC = mainOTVC;
}

- (void)embedTableViewController:(UITableViewController *)tableViewController {
    [self addSubview: tableViewController.view];
    currentEmbeddedTVC = tableViewController; // Set currentEmbeddedTVC property;
}

- (void)updateEmbededTVC:(UITableViewController *)tableViewController {
    if (currentEmbeddedTVC != nil) {
        [currentEmbeddedTVC.view removeFromSuperview];
    }
    CGRect frame = self.frame;
    frame.size.height = tableViewController.tableView.rowHeight * [tableViewController.tableView numberOfRowsInSection: 0];
    self.frame = frame;
    tableViewController.view.frame = self.frame;
    [self addSubview: tableViewController.view];
    currentEmbeddedTVC = tableViewController;
    NSLog(@"updatedEmbededTVC frame - %@", NSStringFromCGRect(currentEmbeddedTVC.view.frame));
    
    if (self.superview) {
        ContainerView* superView = (ContainerView *)self.superview;
        superView.heightConstraint.constant = self.frame.size.height;
        [superView layoutIfNeeded];
        
        
    }
}

#pragma mark - MainOTVCDelegate:
- (void)optionSelected:(MainOptions)option {
    switch(option) {
        case Sort:
        {
            SortOTVC *OTVC = (SortOTVC *)[[UIStoryboard storyboardWithName: @"Options" bundle: nil] instantiateViewControllerWithIdentifier: @"SortOTVC"];
            OTVC.delegate = self;
            [self updateEmbededTVC: OTVC];
            break;
        }
        case Cancel:
        {
            [self.delegate cancelSelected];
            break;
        }
        default:
            break;
    }
}

- (void)sortOptionSelected:(SortOptions)option {
    switch(option) {
        case Hot:
        {
            [self.delegate hotSelected];
            break;
        }
        case Favorite:
        {
            [self.delegate favoriteSelected];
            break;
        }
        case Close:
        {
            [self.delegate cancelSelected];
            break;
        }
        default:
            break;
    }
}



@end
