//
//  StatusView.h
//  Netguru Assignment
//
//  Created by NYC on 23/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusView : UIView

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusActivityIndicatorView;



@end
