//
//  ImageSearchSharedClient.m
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import "ImageSearchSharedClient.h"
#import "SearchImageDetails.h"
#import "Constants.h"

@implementation ImageSearchSharedClient
static NSString * const kImageSearchSharedAPIBaseURLString = @"https://itunes.apple.com/search?term=";


+(ImageSearchSharedClient*)sharedClient{
   static ImageSearchSharedClient *_sharedClient = nil;
    static dispatch_once_t onceT;
    
    dispatch_once(&onceT,^{
        _sharedClient = [[ImageSearchSharedClient alloc]initWithBaseURL:[NSURL URLWithString:kImageSearchSharedAPIBaseURLString]];
    });
    
    return _sharedClient;
}

-(ImageSearchSharedClient*)initWithBaseUrl:(NSURL*)url{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}


-(void)searchImage:(NSString*)param success:(ISSuccessBlock)success failure:(ISFailureBlock)failure{
    
    [[ImageSearchSharedClient sharedClient] GET:[imageSearchAPI stringByAppendingString:param] parameters:nil success:^(NSURLSessionDataTask * operation, id   responseObject) {
        
        NSArray *response = [responseObject valueForKeyPath:@"results"];
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:response.count];
        
        for (NSDictionary *jsonDict in response) {
            SearchImageDetails *searchImageDetails = [[SearchImageDetails alloc]init];
           
            searchImageDetails.artistName = [jsonDict valueForKeyPath:@"artistName"];
            if ((NSNull *)searchImageDetails.artistName == [NSNull null]) {
               searchImageDetails.artistName = @"";
            }
            
            searchImageDetails.songName = [jsonDict valueForKeyPath:@"trackName"];
            if ((NSNull *)searchImageDetails.artistName == [NSNull null]) {
                searchImageDetails.songName = @"";
            }
            
            searchImageDetails.imageURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"artworkUrl100"]];
            [imageArray addObject:searchImageDetails];
        }
       success(operation, imageArray);
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         failure(operation, error);
    }];
}

-(void)getLyrics:(NSString*)param success:(ISSuccessBlock)success failure:(ISFailureBlock)failure{

    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"application/json"]]];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[ImageSearchSharedClient sharedClient] GET:getLyricsAPI parameters:nil success:^(NSURLSessionDataTask * operation, id   responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"Error serializing %@", error);
        }else{
            NSLog(@"JSON Dict %@", JSON);
            NSArray *response = [responseObject valueForKeyPath:@"song"];
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:response.count];
            success(operation, imageArray);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation, error);
    }];
}

@end
