//
//  User+CoreDataProperties.h
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<Article *> *favoriteArticles;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavoriteArticlesObject:(Article *)value;
- (void)removeFavoriteArticlesObject:(Article *)value;
- (void)addFavoriteArticles:(NSSet<Article *> *)values;
- (void)removeFavoriteArticles:(NSSet<Article *> *)values;

@end

NS_ASSUME_NONNULL_END
