//
//  DetailViewController.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/2/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchImageDetails.h"

@interface DetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UITableView *albumDetails;
@property (strong, nonatomic)        SearchImageDetails *deatils;
@property (strong, nonatomic)        NSURL *imageUrl;
@end
