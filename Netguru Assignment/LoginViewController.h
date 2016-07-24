//
//  LoginViewController.h
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+StatusCategory.h"

#import "AppDelegate.h"
#import "User.h"
#import "ViewController.h"
#import "SettingsTVC.h"
#import "StatusView.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) StatusView *currentStatusView;

- (StatusView *)errorStatusWitMessage:(NSString *)message;
- (StatusView *)loggingStatus;

@end
