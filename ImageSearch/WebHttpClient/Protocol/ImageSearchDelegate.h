//
//  ImageSearchDelegate.h
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#ifndef ImageSearchDelegate_h
#define ImageSearchDelegate_h
#import <Foundation/Foundation.h>


typedef void (^ISSuccessBlock)(NSURLSessionDataTask *, NSArray *);
typedef void (^ISFailureBlock)(NSURLSessionDataTask *, NSError *);


@protocol ImageSearching <NSObject>

@required
+(id)sharedClient;
-(void)searchImage:(NSString*)param success:(ISSuccessBlock)success failure:(ISFailureBlock)failure;
-(void)getLyrics:(NSString*)param success:(ISSuccessBlock)success failure:(ISFailureBlock)failure;



@end

#endif /* ImageSearchDelegate_h */
