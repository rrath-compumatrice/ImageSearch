//
//  SearchCollectionViewController.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSearchDelegate.h"

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

- (id<ImageSearching>)searchClient;
- (void)loadImagesforScreen:(int)imageCount;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *lyricsArray;

@end
