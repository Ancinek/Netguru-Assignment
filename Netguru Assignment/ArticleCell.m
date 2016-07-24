//
//  ArticleCell.m
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "ArticleCell.h"
#import "Article.h"
#import "UIImageView+DownloadImage.h"

@implementation ArticleCell 

@synthesize titleLabel;
@synthesize abstractLabel;
@synthesize thumbnailImageView;
@synthesize downloadTask;
@synthesize favorited;
@synthesize cellArticle;
@synthesize cellIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //in seconds
    lpgr.delegate = self;
    [self addGestureRecognizer: lpgr];
    self.expanded = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed: 0/255 green: 0/255 blue: 0/255 alpha: 0.1];
    [self setSelectedBackgroundView:bgColorView];
}


- (void)configureCell:(Article *) article indexPath:(NSIndexPath *)indexPath cache:(NSCache *)cache {
    cellArticle = article;
    cellIndexPath = indexPath;
    self.titleLabel.text = article.title;
    self.abstractLabel.text = article.abstract;
    self.thumbnailImageView.image = [UIImage imageNamed: @"Placeholder"];
        if ([cache objectForKey: article.thumbnailURL] == nil) {
            self.downloadTask = [self.thumbnailImageView loadImageWithURL: article.thumbnailURL cache: cache];
        } else {
            self.thumbnailImageView.image = [cache objectForKey: article.thumbnailURL];
        }
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.expanded = !self.expanded;
        if (self.expanded) {
            self.abstractLabel.numberOfLines = 0;
        } else {
            self.abstractLabel.numberOfLines = 2;
        }
        [UIView animateWithDuration: 0.3 animations:^{
            [self.abstractLabel layoutIfNeeded];
        }];
        [self.delegate toggleExpansion: self.expanded indexPath: cellIndexPath];

        
        NSLog(@"Long press received. Abstract is: %@.\n Cell should now expand? %d.", self.abstractLabel.text, self.expanded);
    }
}

- (IBAction)favoriteButtonTapped:(id)sender {
    [self.delegate favoriteButtonPressed: cellIndexPath];
}




@end
