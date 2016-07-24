//
//  Article+CoreDataProperties.h
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) NSString *abstract;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
