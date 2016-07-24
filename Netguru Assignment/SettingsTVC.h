//
//  SettingsTVC.h
//  Netguru Assignment
//
//  Created by NYC on 23/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SettingCell.h"
#import "HeaderView.h"
#import "User.h"
#import "ContainerView.h"

@interface SettingsTVC : UITableViewController

@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) User* currentUser;

@end
