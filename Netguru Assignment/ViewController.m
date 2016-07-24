//
//  ViewController.m
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "ViewController.h"
#import "Article.h"
#import "ArticleCell.h"
#import "OptionsView.h"
#import "User.h"
#import "AppDelegate.h"

#import "MainOTVC.h"

@interface ViewController ()

// MARK: Properties:
// Stored articles:
@property (strong, nonatomic) NSMutableArray<Article *> *articles;
@property (strong, nonatomic) NSMutableArray<Article *> *sortedArticles;
@property (strong, nonatomic) NSArray<Article *> *searchedArticles;

// Current visible views:
@property (strong, nonatomic) UIView *dimmedView;
@property (strong, nonatomic) ContainerView *visibleContainerView;

// Bool properties:
@property (assign) BOOL searchBarHidden;
@property (assign) BOOL searching;

@end

@implementation ViewController

@synthesize currentUser;
@synthesize articlesTableView;
@synthesize context;
@synthesize currentSort;
@synthesize imageCache;
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup cache:
    imageCache = [[NSCache alloc] init];
    
    // Load cell from nib:
    NSString *nibName = @"ArticleCell";
    UINib *cellNib = [UINib nibWithNibName: nibName bundle: nil];
    [articlesTableView registerNib: cellNib forCellReuseIdentifier: nibName];
    
    // Setup automatic cell height:
    articlesTableView.rowHeight = UITableViewAutomaticDimension;
    articlesTableView.estimatedRowHeight = 90.0;
    
    // Set search bar as hidden:
    self.searchBarHidden = true;
    self.searchBar.delegate = self;
    self.searching = false;
    
    // Refresh controll:
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget: self action: @selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [articlesTableView addSubview: refreshControl];
    [articlesTableView sendSubviewToBack: refreshControl];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [refreshControl beginRefreshing];
    [self handleRefresh: refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [self performSearch];
    [articlesTableView layoutIfNeeded];
    [self.refreshControl endRefreshing];
}

// MARK: Parsing methods:
- (id)parseJSON:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &error];
    if (error) {
        NSLog(@"Error parsing JSON.");
        return nil;
    }
    NSArray *items = [dictionary objectForKey: @"items"];
    return items;
}

- (NSMutableArray<Article*> *)parseArray:(NSArray *) array {
    NSMutableArray<Article*> *articles = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Article" inManagedObjectContext: context];
    for (NSDictionary *item in array) {
        Article *article = [[Article alloc] initWithEntity: entity insertIntoManagedObjectContext: nil];
        article.title = [item objectForKey: @"title"];
        article.abstract = [item objectForKey: @"abstract"];
        article.thumbnailURL = [item objectForKey: @"thumbnail"];
        article.url = [item objectForKey: @"url"];
        [articles addObject: article];
    }
    
    return articles;
}

- (void)performSearch {
    currentSort = Hot;
    
    [self.articles removeAllObjects];
    NSString *category = @"Characters";
    int limit = 75;
    NSString *address = [NSString stringWithFormat:@"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=%@&limit=%d", category, limit];
    NSURL *url = [NSURL URLWithString: address];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL: url
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error != nil) {
                                                    NSLog(@"There was an error in dataTask.");
                                                    // Further implementation needed...
                                                    return;
                                                }
                                                if (data != nil) {
                                                    NSArray *array = [self parseJSON:data];
                                                    if (array != nil) {
                                                        self.articles = [self parseArray: array];
                                                        self.sortedArticles = [self.articles mutableCopy];
                                                        dispatch_async(dispatch_get_main_queue(), ^(void){
                                                            [articlesTableView reloadData];
                                                        });
                                                    } else {
                                                        return;
                                                    }
                                                } else {
                                                    return;
                                                }
                                            }];
    [dataTask resume];
}


// MARK: IBActions:
- (IBAction)searchButtonTapped:(id)sender {
    CGFloat height = self.navigationBar.frame.size.height;
    [UIView animateWithDuration: 0.5 animations:^{
        self.searchBarTC.constant = self.searchBarHidden ? height : 0.0;
        self.articlesTableViewTC.constant = self.searchBarHidden ? height : 0.0;
        [self.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchBarTC.constant = self.searchBarHidden ? height : 0.0;
                         self.articlesTableViewTC.constant = self.searchBarHidden ? height : 0.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.searchBarHidden = !self.searchBarHidden;
                         self.searchBar.text = @"";
                         self.searchBarHidden ? [self.searchBar resignFirstResponder] : [self.searchBar becomeFirstResponder];
                     }];
    
    
}


- (IBAction)optionsButtonTapped:(id)sender {
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    
    if (!self.visibleContainerView) {
        // Init optionsView:
        OptionsView *optionsView = [[OptionsView alloc] initWithSuperview: self.view];
        optionsView.delegate = self;
        // Dim background:
        [self toggleDim];
        
        // Add container view:
        ContainerView *containerView = [[ContainerView alloc] init];
        [containerView constraintSetup: optionsView];
        [containerView initialPosition: Bottom parentViewController: self.tabBarController];
        [containerView displayContentView: optionsView];
        [containerView show];
        self.visibleContainerView = containerView;
        
    }
}
// MARK: View's functions:
- (void)hideContainerView {
    [self.visibleContainerView hide];
    self.visibleContainerView = nil;
    [self toggleDim];
    
}

- (void)toggleDim {
    if (!self.dimmedView) {
        self.dimmedView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        self.dimmedView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 1.0f];
        self.dimmedView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(hideContainerView)];
        //[tap addTarget: self action: @selector(hideDetail)];
        tap.delegate = self;
        [self.dimmedView addGestureRecognizer: tap];
        [self.tabBarController.view addSubview: self.dimmedView];
        [self constraintsToBorders: self.dimmedView ofParentView: self.tabBarController.view];
        [UIView animateWithDuration: 0.3 animations:^{
            self.dimmedView.alpha = 0.5;
        } completion:^(BOOL finished) {
            // Possible future use...
        }];
        return;
    } else {
        [UIView animateWithDuration: 0.3 animations:^{
            self.dimmedView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.dimmedView removeFromSuperview];
            self.dimmedView = nil;
        }];
    }
}


#pragma mark - ArticleCellDelegate:
- (void)toggleExpansion:(BOOL)shouldExpand indexPath:(NSIndexPath *)indexPath {
    [articlesTableView beginUpdates];
    [articlesTableView endUpdates];
}

- (void)favoriteButtonPressed:(NSIndexPath *)indexPath {
    if (currentUser != nil) {
        NSError *error = nil;
        User *user = currentUser;
        
        // Get tapped article
        Article *tappedArticle = self.searching ? [self.searchedArticles objectAtIndex: indexPath.row] : [self.sortedArticles objectAtIndex: indexPath.row];
        BOOL articleAlreadyAdded = false;
        
        // Check if user already has favorite this article:
        Article *matchingArticle;
        for (Article* article in user.favoriteArticles) {
            if ([article.abstract isEqualToString: tappedArticle.abstract]) {
                articleAlreadyAdded = true;
                matchingArticle = article;
            }
        }
        if (!articleAlreadyAdded) {
            NSEntityDescription *entity = [NSEntityDescription entityForName: @"Article" inManagedObjectContext: context];
            Article *favoritedArticle = [[Article alloc]  initWithEntity: entity insertIntoManagedObjectContext:context];
            favoritedArticle.title = tappedArticle.title;
            favoritedArticle.abstract = tappedArticle.abstract;
            favoritedArticle.thumbnailURL = tappedArticle.thumbnailURL;
            favoritedArticle.user = user;
            [user addFavoriteArticlesObject: favoritedArticle];
            [context save: &error];
        } else {
            [user removeFavoriteArticlesObject: matchingArticle];
            [context deleteObject: matchingArticle];
            [context save: &error];
        }
        
        
        switch (currentSort) {
            case Hot:
                [self performSearch];
                break;
            case Favorite:
            {
                // Sort alphabetically:
                self.sortedArticles = [[currentUser.favoriteArticles allObjects] mutableCopy];
                self.sortedArticles = [[self.sortedArticles sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSString *first = [(Article*)a title];
                    NSString *second = [(Article*)b title];
                    return [first compare:second];
                }] mutableCopy];
                [articlesTableView reloadData];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - OptionsViewDelegate:
- (void)cancelSelected {
    [self hideContainerView];
}
- (void)hotSelected {
    currentSort = Hot;
    if (!self.searching) {
        [self performSearch];
    }
    // Search sorting:
    if (self.searching) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title CONTAINS[cd] %@", self.searchBar.text];
        NSMutableArray *result = [self.articles mutableCopy];
        [result filterUsingPredicate: predicate];
        self.searchedArticles = [result mutableCopy];
    }
    [self hideContainerView];
    [articlesTableView reloadData];
    
}
- (void)favoriteSelected {
    currentSort = Favorite;
    self.sortedArticles = nil;
    self.sortedArticles = [[currentUser.favoriteArticles allObjects] mutableCopy];
    // Search sorting:
    if (self.searching) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (Article *sortedArticle in self.sortedArticles) {
            for (Article *searchedArticle in self.searchedArticles) {
                if (sortedArticle.title == searchedArticle.title) {
                    [result addObject: searchedArticle];
                }
            }
        }
        self.searchedArticles = [result copy];
    }
    [articlesTableView reloadData];
    [self hideContainerView];
}

#pragma mark - DetailViewDelegate:
- (void)articleVisited {
    [self hideContainerView];
}

#pragma mark - TableViewDataSource:
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"ArticleCell";
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = (ArticleCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    
    cell.cellIndexPath = indexPath;
    [cell setDelegate: self];
    
    // Dislplay results based on searching property:
    Article *article = self.searching ? [self.searchedArticles objectAtIndex: indexPath.row] : [self.sortedArticles objectAtIndex: indexPath.row];
    
    
    NSArray *results = [self fetchArticlesFor: currentUser];
    for (Article* favArt in results) {
        if ([article.abstract isEqualToString: favArt.abstract]) {
            cell.favorited = true;
            [cell.favoriteButton setImage: [UIImage imageNamed: @"favorite"] forState: UIControlStateNormal];
            break;
        }
        [cell.favoriteButton setImage: [UIImage imageNamed: @"not_favorite"] forState: UIControlStateNormal];
    }
    [cell configureCell: article indexPath: indexPath cache: imageCache];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searching ? self.searchedArticles.count : self.sortedArticles.count;
}

#pragma mark - UITableViewDelegate:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    ArticleCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    
    // Initialize and setup detailView:
    DetailView *detailView = [[[NSBundle mainBundle] loadNibNamed: @"DetailView" owner: self options:nil] objectAtIndex: 0];
    [detailView setupView: cell.cellArticle];
    detailView.delegate = self;
    detailView.thumbnailImageView.image = cell.thumbnailImageView.image;
    
    // Dim background:
    [self toggleDim];
    
    // Add container view:
    ContainerView *containerView = [[ContainerView alloc] init];
    [containerView constraintSetup: detailView];
    [containerView initialPosition: Center parentViewController: self.tabBarController];
    [containerView displayContentView: detailView];
    [containerView show];
    self.visibleContainerView = containerView;
}

#pragma mark - UIBarPositioningDelegate:
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return true;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setPlaceholder:@"Search character"];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton: false animated: true];
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setPlaceholder:@"Select languages"];
    [articlesTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.searching = true;
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title CONTAINS[cd] %@", searchText];
        NSArray *searchResults = [self.sortedArticles copy];
        NSArray *filteredResults = [searchResults filteredArrayUsingPredicate: predicate];
        self.searchedArticles = filteredResults;
        [articlesTableView reloadData];
    }
    if (searchText.length == 0) {
        self.searching = false;
        [articlesTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (NSArray *)fetchArticlesFor:(User *) user {
    NSArray *result = [currentUser.favoriteArticles allObjects];
    //NSLog(@"fetchArticlesFor - result: %@.", result);
    return result;
}
- (void)constraintsToBorders:(UIView *) view
                ofParentView:(UIView *) parentView {
    view.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: parentView attribute:NSLayoutAttributeTop multiplier: 1.0 constant: 0.0].active = true;
    [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: parentView attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0].active = true;
    [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: parentView attribute:NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0].active = true;
    [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: parentView attribute:NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0].active = true;
}


@end
