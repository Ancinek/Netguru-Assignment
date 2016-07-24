//
//  JoinViewController.m
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "JoinViewController.h"
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "LoginViewController.h"

@interface JoinViewController ()
{
    NSManagedObjectContext *context;
}

@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    
    [self.logInButton.layer setBorderWidth: 1.5];
    [self.logInButton.layer setBorderColor: [UIColor whiteColor].CGColor ];
    
    // Gradient:
    UIColor *firstColor = [UIColor colorWithHEX: @"#232526"];
    UIColor *secondColor = [UIColor colorWithHEX: @"#414345"];
    [self gradientStart: firstColor end: secondColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SignupScreenSegue"]) {
        SignupViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.context = context;
        return;
    }
    if ([segue.identifier isEqualToString: @"LoginScreenSegue"]) {
        LoginViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.context = context;
        return;
    }
}

- (IBAction)logInButtonTapped:(id)sender {
    // Possible future use...
}

- (IBAction)signInButtonTapped:(id)sender {
    // Possible future use...
}

- (IBAction)skipThisStepTapped:(id)sender {
    // Possible future use...
}
#pragma mark - Autorotation
- (BOOL)shouldAutorotate {
    return false;
}



@end
