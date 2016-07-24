//
//  OptionCell.m
//  Netguru Assignment
//
//  Created by NYC on 20/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "OptionCell.h"

@implementation OptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSDictionary *) dictionary {
    self.optionLabel.text = [dictionary valueForKey: @"text"];
    self.optionImageView.image = [UIImage imageNamed: [dictionary valueForKey: @"image"]];
    self.backgroundColor = [UIColor whiteColor];
}


@end
