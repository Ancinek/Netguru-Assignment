//
//  OptionCell.h
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

- (void)configureCell:(NSDictionary *) dictionary;


@end
