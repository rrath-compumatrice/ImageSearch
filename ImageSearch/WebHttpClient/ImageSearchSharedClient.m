//
//  ImageSearchSharedClient.m
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import "ImageSearchSharedClient.h"
#import "SearchImageDetails.h"

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
    
    NSString *baseUrl = @"https://itunes.apple.com/search?term=";
    [[ImageSearchSharedClient sharedClient] GET:[baseUrl stringByAppendingString:param] parameters:nil success:^(NSURLSessionDataTask * operation, id   responseObject) {
        
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
    NSString *baseUrl = @"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json";
   // [self.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"application/json"]]];
     self.requestSerializer = [AFJSONRequestSerializer serializer];
    [[ImageSearchSharedClient sharedClient] GET:baseUrl parameters:nil success:^(NSURLSessionDataTask * operation, id   responseObject) {
        
        NSArray *response = [responseObject valueForKeyPath:@"results"];
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:response.count];
        
        success(operation, imageArray);
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation, error);
    }];
}

@end
