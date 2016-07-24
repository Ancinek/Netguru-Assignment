//
//  DetailView.m
//  Netguru Assignment
//
//  Created by NYC on 21/07/2016.
//  Copyright © 2016 Brook & Co. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

- (void)setupView:(Article *)article {
    self.titleLabel.text = article.title;
    self.abstractLabel.text = article.abstract;
    self.article = article;
}

- (IBAction)visitButtonTapped:(id)sender {
    NSLog(@"URL: %@.", self.article.url);
    NSString *url = [NSString stringWithFormat: @"http://gameofthrones.wikia.com%@", self.article.url];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    [self.delegate articleVisited];
}

@end
