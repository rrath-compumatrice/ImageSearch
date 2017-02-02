//
//  SearchCollectionViewController.m
//  ImageSearch
//
//  Created by Swagatika Rath on 2/1/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import "SearchCollectionViewController.h"
#import "ImageSearchSharedClient.h"
#import "SearchImageTableViewCell.h"
#import "SearchImageDetails.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *seachTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation SearchViewController

static  NSString * const CellIdentifier = @"SearchImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seachTableView.delegate = self;
    self.seachTableView.dataSource = self;
    _images = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    SearchImageDetails *searchImageDetails = [self.images objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"AlbumDetail" sender:searchImageDetails];
    [self.seachTableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.images count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath");
    SearchImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    SearchImageDetails *deatils = [_images objectAtIndex:indexPath.row];
    
    // Update cell data contents
    cell.artistNameLbl.text = deatils.artistName;
    cell.songLbl.text = deatils.songName;
    cell.imageContainer.backgroundColor = [UIColor lightGrayColor];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:deatils.imageURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder@2x"];
    
    __weak SearchImageTableViewCell *weakCell = cell;
    
    [cell.imageContainer setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageContainer.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    
    // Check if this has been the last item, if so start loading more images...
    if (indexPath.row == [self.images count] - 1) {
        [self loadImagesforScreen:(int)[self.images count]];
    };
    
    return cell;
}

- (id<ImageSearching>)searchClient{
    NSString *searchProviderString = @"ImageSearchSharedClient";
    id<ImageSearching> sharedClient = [NSClassFromString(searchProviderString) sharedClient];
    //NSAssert(sharedClient, @"Invalid class string from settings encountered");
    return sharedClient;
}


- (void)loadImagesforScreen:(int)imageCount{
    if ([self.searchBar.text isEqualToString:@""]) {
        return;
    }
    if (imageCount == 0) {
        [self.images removeAllObjects];
        [self.seachTableView reloadData];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    __weak SearchViewController *weakSelf = self;
    
    [[self searchClient]searchImage:self.searchBar.text success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
       [weakSelf.images addObjectsFromArray:imageArray];
        [self.seachTableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
   } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
       NSLog(@"An error occured while searching for images, %@", [error description]);
   }];
    
    [[self searchClient]getLyrics:self.searchBar.text success:^(NSURLSessionDataTask *dataTask, NSArray *lyricsArray) {
        [weakSelf.lyricsArray addObjectsFromArray:lyricsArray];
        [self.seachTableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });

    } failure:^(NSURLSessionDataTask *datatask, NSError *error) {
         NSLog(@"An error occured while searching for images, %@", [error description]);
    }];

}

#pragma mark - <UIsearchBarDelegate>
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self loadImagesforScreen:0];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"AlbumDetail"]) {
        SearchImageDetails *details = sender;
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.deatils = details;
        
    }
}



@end
