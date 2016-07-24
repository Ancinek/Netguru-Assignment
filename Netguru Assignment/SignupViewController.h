//
//  SignupViewController.h
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+StatusCategory.h"
#import "StatusView.h"
#import "ViewController.h"
#import "SettingsTVC.h"


@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *wolfImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

// Constraints:
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wolfImageViewTC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpTC;
@property (assign) BOOL keyboardVisible;

@property (assign) CGFloat wolfMovement;
@property (assign) CGFloat signupMovement;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) StatusView *currentStatusView;

- (StatusView *)errorStatusWitMessage:(NSString *)message;
- (StatusView *)signingStatus;


@end
