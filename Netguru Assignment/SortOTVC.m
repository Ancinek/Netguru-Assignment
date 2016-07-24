//
//  SortOTVC.m
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "SortOTVC.h"

@interface SortOTVC ()

@end

@implementation SortOTVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    switch (indexPath.row) {
        case 0:
        {
            [self.delegate sortOptionSelected: Favorite];
            break;
        }
        case 1:
        {
            [self.delegate sortOptionSelected: Hot];
            break;
        }
        case 2:
            [self.delegate sortOptionSelected: Close];
            break;
        default:
            break;
    }
}

@end
