//
//  ImageSearchSharedClient.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
#import "ImageSearchDelegate.h"

@interface ImageSearchSharedClient :AFHTTPSessionManager<ImageSearching>

+(ImageSearchSharedClient*)sharedClient;




@end
