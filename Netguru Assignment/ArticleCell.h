//
//  ArticleCell.h
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol ArticleCellDelegate <NSObject>
- (void)toggleExpansion:(BOOL) shouldExpand
              indexPath:(NSIndexPath *) indexPath;
- (void)favoriteButtonPressed:(NSIndexPath *) indexPath;
@end


@interface ArticleCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *abstractLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) Article *cellArticle;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, assign) BOOL favorited;

@property (nonatomic, weak) id<ArticleCellDelegate>delegate;


- (void)configureCell:(Article *) article
            indexPath:(NSIndexPath *) indexPath
                cache:(NSCache *) cache;


@end
