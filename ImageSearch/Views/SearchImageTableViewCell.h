//
//  SearchImageTableViewCell.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *artistNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageContainer;
@property (weak, nonatomic) IBOutlet UILabel *songLbl;
@property (nonatomic, strong) NSMutableArray *images;
@end
