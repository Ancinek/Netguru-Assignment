//
//  SortOTVC.h
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Hot, Favorite, Close
} SortOptions;

@protocol SortOTVCDelegate <NSObject>

- (void)sortOptionSelected:(SortOptions)option;

@end

@interface SortOTVC : UITableViewController

@property (nonatomic, weak) id<SortOTVCDelegate>delegate;

@end
