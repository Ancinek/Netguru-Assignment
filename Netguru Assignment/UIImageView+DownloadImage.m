//
//  UIImageView+DownloadImage.m
//  Netguru Assignment
//
//  Created by NYC on 19/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "UIImageView+DownloadImage.h"

@implementation UIImageView (DownloadImage)


- (NSURLSessionDownloadTask *)loadImageWithURL:(NSString *)url
                                         cache:(NSCache *)cache {
    NSURL *imageURL = [NSURL URLWithString: url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL: imageURL
                                                        completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            if ((error == nil) && (location != nil)) {
                                                                NSData *data = [NSData dataWithContentsOfURL: location];
                                                                UIImage *image = [UIImage imageWithData: data];
                                                                [cache setObject: image forKey: url];
                                                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                    self.image = image;
                                                                });
                                                                
                                                            }
                                                        }];
    [downloadTask resume];
    return downloadTask;
}

@end
