//
//  UIImageView+DownloadImage.h
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

- (NSURLSessionDownloadTask *)loadImageWithURL:(NSString *)url
                                         cache:(NSCache *)cache;
@end
