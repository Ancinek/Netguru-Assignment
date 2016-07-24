//
//  MainOTVC.h
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Sort, Cancel
} MainOptions;

@protocol MainOTVCDelegate <NSObject>

- (void)optionSelected:(MainOptions)option;

@end

@interface MainOTVC : UITableViewController

@property (nonatomic, weak) id<MainOTVCDelegate>delegate;

@end
