//
//  DetailViewController.m
//  ImageSearch
//
//  Created by Swagatika Rath on 2/2/17.
//  Copyright © 2017 Swagatika Rath. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark <ViewLifeCycle>

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albumDetails.delegate= self;
    self.albumDetails.dataSource= self;
    
    self.albumDetails.rowHeight = 80;
    self.albumDetails.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self setImageForView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 
 @method
 
 setImageForView
 
 @discussion This method set the Image accesed from SearchViewController.
 
 */

#pragma mark <setImageForView>

-(void)setImageForView{
    
    // Show a loading spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Start loading image
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_deatils.imageURL];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak DetailViewController *weakSelf = self;
    
    [self.albumImage setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       // Set the image
                                       weakSelf.albumImage.image = image;
                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"An error occured when loading the image, %@", [error description]);
                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                   }];

}

#pragma mark <UITabeViewDelegate>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark <UITabeViewDataSource>

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSString *identifier = @"DeatilIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Artist Name";
            cell.detailTextLabel.text = _deatils.artistName;
            break;
        case 1:
            cell.textLabel.text = @"Song Name";
            cell.detailTextLabel.text = _deatils.songName;
            break;
        case 2:
            cell.textLabel.text = @"Lyrics";
            cell.detailTextLabel.text = _deatils.lyrics;
            break;
        default:
            break;
    }
   
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
