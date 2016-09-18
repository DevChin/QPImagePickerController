//
//  QPImagePickerViewController.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPImagePickerViewController.h"
#import "QPImagePickerDataSourceManager.h"
#import "QPAlbum.h"
#import "QPPhotosViewController.h"

//the albumsViewController to display Albums info

@interface QPAlbumsViewController : UITableViewController
{
    NSMutableArray* _albums; // the  array of albums
}
@property (nonatomic,assign)NSInteger maxCanSelectdCount;
@property (nonatomic,assign)id<QPImagePickerViewControllerDelegate,UINavigationControllerDelegate> delegate;
@end

@implementation QPImagePickerViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nil bundle:nil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    QPAlbumsViewController* albumController = [[QPAlbumsViewController alloc] initWithStyle:UITableViewStylePlain];
    albumController.maxCanSelectdCount=self.maxCanSelectdCount;
    albumController.delegate=self.delegate;
    [self pushViewController:albumController animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@implementation QPAlbumsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"相册";
    [self createAlbumdModels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark create Album model

- (void)createAlbumdModels {
    
    _albums=[[NSMutableArray alloc] init];
    
    for (PHAssetCollection * collection in [[QPImagePickerDataSourceManager sharedInstance] albums]) {
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"])
        {
            QPAlbum* album = [[QPAlbum alloc] init];
            PHFetchResult* assetResult = [[QPImagePickerDataSourceManager sharedInstance] assetsInCollection:collection];
            album.count=assetResult.count;
            album.name=@"相机胶卷";
            if (album.count > 0)
            album.thumbnailAsset=assetResult.firstObject;
            
            PHFetchResult* result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            NSMutableArray* photos=[[NSMutableArray alloc] init];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAsset* asset = (PHAsset*)obj;
                //the type is image
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    QPPhoto* photo = [[QPPhoto alloc] init];
                    photo.selected=NO;
                    photo.imageAsset=asset;
                    [photos addObject:photo];
                }
            }];
            album.photoModels=photos;
            [_albums addObject:album];
        }
    }
    
    for (PHAssetCollection * collection in [[QPImagePickerDataSourceManager sharedInstance] userAlbums]) {
        QPAlbum* album = [[QPAlbum alloc] init];
        PHFetchResult* assetResult = [[QPImagePickerDataSourceManager sharedInstance] assetsInCollection:collection];
        album.count=assetResult.count;
        album.name=collection.localizedTitle;
        if (album.count > 0)
            album.thumbnailAsset=assetResult.firstObject;
        PHFetchResult* result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSMutableArray* photos=[[NSMutableArray alloc] init];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset* asset = (PHAsset*)obj;
            //the type is image
            if (asset.mediaType == PHAssetMediaTypeImage) {
                QPPhoto* photo = [[QPPhoto alloc] init];
                photo.selected=NO;
                photo.imageAsset=asset;
                [photos addObject:photo];
            }
        }];
        album.photoModels=photos;
        [_albums addObject:album];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"album-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if  (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        posterImageView.clipsToBounds = YES;
        posterImageView.tag=1;
        posterImageView.frame = CGRectMake(0, 0, 60, 60);
        [cell.contentView addSubview:posterImageView];
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont boldSystemFontOfSize:17];
        titleLable.frame = CGRectMake(75,20,self.view.bounds.size.width-105,20);
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.tag=2;
        [cell.contentView addSubview:titleLable];
        
        UIButton* countButton=[UIButton buttonWithType:UIButtonTypeCustom];
        countButton.frame=CGRectMake(self.view.frame.size.width-64,10,24,24);
        countButton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        [countButton setBackgroundImage:[UIImage imageNamed:@"photo_number_icon"] forState:UIControlStateNormal];
        countButton.hidden=YES;
        countButton.tag=3;
        [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:countButton];
        
    }

    QPAlbum* album = _albums[indexPath.row];
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    UILabel* titleLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UIButton* countButton = (UIButton*)[cell.contentView viewWithTag:3];
    [[QPImagePickerDataSourceManager sharedInstance] requestThumbnailImageWithAsset:album.thumbnailAsset andThumbnailSize:CGSizeMake(80, 80) andCompletionHandle:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if  (!info[PHImageErrorKey] && info[PHImageResultRequestIDKey] && result)
            imageView.image=result;
    }];
    NSMutableAttributedString* attributeTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  (%ld)",album.name,(long)album.count] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attributeTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(album.name.length,attributeTitle.length-album.name.length)];
    titleLabel.attributedText=attributeTitle;
    if (album.selectedModels.count > 0) {
        countButton.hidden=NO;
        [countButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)album.selectedModels.count] forState:UIControlStateNormal];
    }else{
        countButton.hidden=YES;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QPAlbum* album = _albums[indexPath.row];
    QPPhotosViewController* photoVC=[[QPPhotosViewController alloc] init];
    photoVC.albumModel=album;
    photoVC.delegate=_delegate;
    photoVC.maxCanSelectdCount=self.maxCanSelectdCount;
    [self.navigationController pushViewController:photoVC animated:YES];
}

@end
