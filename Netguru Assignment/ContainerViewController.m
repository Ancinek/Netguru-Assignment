//
//  ContainerViewController.m
//  Netguru Assignment
//
//  Created by NYC on 22/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.view addSubview: self.currentClientView];
    [content didMoveToParentViewController:self];
}

@end
