//
//  ViewController.h
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ArticleCell.h"
#import "OptionsView.h"
#import "SortOTVC.h"
#import "DetailView.h"
#import "User.h"

#import "ContainerView.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ArticleCellDelegate, OptionsViewDelegate, DetailViewDelegate, UIBarPositioningDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (assign) SortOptions currentSort;

// Bars
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


// Constraints:
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articlesTableViewTC;

// Cache:
@property (strong, nonatomic) NSCache *imageCache;

// Refresh controll:
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

