//
//  SettingsTVC.m
//  Netguru Assignment
//
//  Created by NYC on 23/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC

@synthesize settings;
@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Settings" ofType: @"plist"];
    settings = [NSArray arrayWithContentsOfFile: path];
    
    self.tableView.scrollEnabled = false;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[settings objectAtIndex: section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SettingCell" forIndexPath:indexPath];
    NSDictionary *setting = [[settings objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    // Configure the cell...
    cell.mainLabel.text = [setting valueForKey: @"text"];
    cell.settingImageView.image = [UIImage imageNamed: [setting valueForKey: @"image"]];
    cell.infoLabel.hidden = indexPath.section == 0 ? false : true;
    if (indexPath.section == 0) {
        cell.infoLabel.hidden = false;
        if (indexPath.row == 0) { cell.infoLabel.text = currentUser.username; }
        if (indexPath.row == 1) { cell.infoLabel.text = currentUser.email; }
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    NSLog(@"Selected indexPath %@", indexPath);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: // Username
                    // Possible future use...
                    break;
                case 1: // Email
                    // Possible future use...
                    break;
                default:
                    break;
            }
            return;
        }
        case 1:
            switch (indexPath.row) {
                case 0: // Official site
                {
                    NSString *url = @"http://gameofthrones.wikia.com";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
                    return;
                }
                case 1: // Credits
                {
                    NSString *url = @"http://netguru.co";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
                    return;
                }
                default:
                    break;
            }
            return;
        case 2:
            switch (indexPath.row) {
                case 0: // Logout
                {
                    self.currentUser = nil;
                    ViewController *viewController = (ViewController *)[[self.tabBarController viewControllers] objectAtIndex: 0];
                    viewController.currentUser = nil;
                    [self dismissViewControllerAnimated: true completion: nil];
                    return;
                }
                default:
                    break;
            }
            return;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 70.0;
        case 1:
            return 50.0;
        case 2:
            return 50.0;
        default:
            return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] objectAtIndex:0];
    switch (section) {
        case 0:
            headerView.headerLabel.text = @"Account";
            break;
        case 1:
            headerView.headerLabel.text = @"About";
            break;
        default:
            headerView.headerLabel.text = @"";
            break;
    }
    return headerView;
}

@end
