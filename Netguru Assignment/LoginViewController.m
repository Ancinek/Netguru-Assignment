//
//  LoginViewController.m
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
{
    User *loggedUser;
    UIGestureRecognizer *tapGesture;
}
@end

@implementation LoginViewController

@synthesize context;
@synthesize currentStatusView;
@synthesize keyboardVisible;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Resign first responder on tap:
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.cancelsTouchesInView = false;
    [self.view addGestureRecognizer:tapGesture];
    
    // Login button setup:
    [self.logInButton.layer setBorderWidth: 1.5];
    [self.logInButton.layer setBorderColor: [UIColor whiteColor].CGColor ];
    
    // Gradient:
    UIColor *firstColor = [UIColor colorWithHEX: @"#232526"];
    UIColor *secondColor = [UIColor colorWithHEX: @"#414345"];
    [self gradientStart: firstColor end: secondColor];
    
    // Textfield setup:
    NSArray *textfields = @[self.usernameTextfield, self.passwordTextfield];
    NSArray *texts = @[@"Type in your username", @"And now password"];
    for (int i = 0; i < [textfields count]; i++) {
        UITextField *textfield = [textfields objectAtIndex: i];
        [textfield textfieldWithBottomBorderWidth: 1.5 color: [[UIColor whiteColor] colorWithAlphaComponent: 0.7]];
        [textfield placeholderColor:[[UIColor whiteColor] colorWithAlphaComponent: 0.6] withText: [texts objectAtIndex: i]];
        textfield.delegate = self;
    }
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing: true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"LoginSegue"]) {
        UITabBarController *destinationTabController = [segue destinationViewController];
        ViewController *destinationViewController = (ViewController *)[[destinationTabController viewControllers] objectAtIndex: 0];
        destinationViewController.currentUser = loggedUser;
        destinationViewController.context = context;
        SettingsTVC *settingsTVC = (SettingsTVC *)[[destinationTabController viewControllers] objectAtIndex: 1];
        settingsTVC.currentUser = loggedUser;
    }
}

- (IBAction)logInButtonTapped:(id)sender {
    NSString *entityName = @"User";
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName: entityName];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest: request error: &error];
    if (error != nil) {
        NSLog(@"logInButtonTapped - error.");
    } else {
        NSString *username = self.usernameTextfield.text;
        NSString *password = self.passwordTextfield.text;
        for (User* user in results) {
            if ([user.username isEqualToString: username]) {
                if ([user.password isEqualToString: password]) {
                    loggedUser = user;
                    currentStatusView = [self loggingStatus];
                    return;
                }
                currentStatusView = [self errorStatusWitMessage: @"Wrong password."];
                self.passwordTextfield.text = @"";
                return;
            }
            currentStatusView = [self errorStatusWitMessage: @"Wrong username or password."];
            return;
        }
    }
    
}

- (IBAction)revealPasswordButtonTapped:(id)sender {
    BOOL secure = [self.passwordTextfield isSecureTextEntry];
    [self.passwordTextfield setSecureTextEntry: !secure];
}


- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated: true completion: nil];
}

- (StatusView *)loggingStatus {
    return [self displayStatusViewWithMessage: @"Logging in..."
                     currentStatusView: currentStatusView
                               loading: true
                                 error: false
                            completion:^{
                                [self hideStatusViewWithDelay: 1.0
                                            currentStatusView: currentStatusView
                                                   completion:^{
                                                       currentStatusView = nil;
                                                       [self performSegueWithIdentifier: @"LoginSegue" sender: self];
                                                   }];
                            }];
}

- (StatusView *)errorStatusWitMessage:(NSString *)message {
    return [self displayStatusViewWithMessage: message
                            currentStatusView: currentStatusView
                                      loading: false
                                        error: true
                                   completion:^{
                                       [self hideStatusViewWithDelay: 2.0
                                                   currentStatusView: currentStatusView
                                                          completion:^{
                                                              currentStatusView = nil;
                                                          }];
                                   }];
}

#pragma mark - UITextFieldDelegate:
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIColor *blueColor = [UIColor colorWithRed: 33.0/255.0 green: 150.0/255.0 blue: 243.0/255.0 alpha:1.0];
    [textField.layer.sublayers objectAtIndex: 0].borderColor = blueColor.CGColor;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIColor *whiteColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.7];
    [textField.layer.sublayers objectAtIndex: 0].borderColor = whiteColor.CGColor;
}

#pragma mark - Autorotation:
- (BOOL)shouldAutorotate {
    return false;
}

#pragma mark - Keyboard notifications:
- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!keyboardVisible) {
        NSDictionary *info = [notification userInfo];
        NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardFrame = [kbFrame CGRectValue];
        // Calculate and animate movement
        CGFloat keyboardY = keyboardFrame.origin.y;
        CGFloat difference = self.logInButton.frame.origin.y - keyboardY;
        CGFloat finalValue = difference + (self.logInButton.frame.size.height * 1.5);
        self.signupMovement = finalValue;
        CGFloat wolfImageHeight = self.wolfImageView.frame.size.height;
        CGFloat imageScale = (wolfImageHeight - finalValue) / wolfImageHeight;
        CGAffineTransform scale = CGAffineTransformMakeScale(imageScale, imageScale);
        self.wolfMovement = finalValue * imageScale;
        
        // Set constants:
        self.loginTC.constant -= finalValue;
        self.wolfImageViewTC.constant -= finalValue * imageScale;
        if ([UIScreen mainScreen].bounds.size.width <= 500) {
            self.wolfImageView.alpha = 0.0;
        }
        
        [UIView animateWithDuration:animationDuration animations:^{
            if ([UIScreen mainScreen].bounds.size.width > 500) {
                self.wolfImageView.transform = scale;
            }
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.loginTC.constant += self.signupMovement;
    self.wolfImageViewTC.constant += self.wolfMovement;
    //
    [UIView animateWithDuration: animationDuration animations:^{
        if ([UIScreen mainScreen].bounds.size.width > 500) {
            self.wolfImageView.transform =  CGAffineTransformMakeScale(1.0, 1.0);
        } else {
            self.wolfImageView.alpha = 1.0;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    keyboardVisible = true;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    keyboardVisible = false;
}



@end
