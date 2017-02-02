//
//  SearchImageDetails.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchImageDetails : NSObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic, strong) NSURL *imageURL;

@end
