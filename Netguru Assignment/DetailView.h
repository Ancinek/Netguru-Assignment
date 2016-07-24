//
//  DetailView.h
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol DetailViewDelegate <NSObject>

-(void)articleVisited;

@end

@interface DetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;

@property (assign) CGRect *referenceFrame;
@property (nonatomic, weak) id<DetailViewDelegate>delegate;
@property (nonatomic, strong) Article *article;


- (void)setupView:(Article *)article;

@end
