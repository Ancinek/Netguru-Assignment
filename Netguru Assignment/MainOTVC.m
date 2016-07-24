//
//  MainOTVC.m
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "MainOTVC.h"

@interface MainOTVC ()

@end

@implementation MainOTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    switch (indexPath.row) {
    case 0:
        {
            [self.delegate optionSelected: Sort];
            break;
    }
    case 1:
        {
            [self.delegate optionSelected: Cancel];
            break;
        }
    default:
        break;
    }
}


@end
