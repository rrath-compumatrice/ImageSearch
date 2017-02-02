//
//  SearchImageDetails.m
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import "SearchImageDetails.h"

@implementation SearchImageDetails
@synthesize artistName;
- (id)init
{
    self = [super init];
    if (self) {
        artistName = @"";
        _songName = @"";
    }
    
    return self;
}

@end
