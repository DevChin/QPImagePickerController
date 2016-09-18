//
//  QPPhotosViewController.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPPhotosViewController.h"
#import "QPImageCell.h"
#import "QPPreViewViewController.h"
#import "QPToolBar.h"
#import "QPImagePickerDataSourceManager.h"

@interface QPPhotosViewController () <QPImageCellDelegate,QPToolBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    QPToolBar* _toolBar; //the bottonView
    UICollectionView* _collectionView;
}
@end

@implementation QPPhotosViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=_albumModel.name;
    
    [self initNavigationBar];
    self.view.backgroundColor=[UIColor whiteColor];
    _selectPhotoModels=_albumModel.selectedModels;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self setCollectionView];

    // Do any additional setup after loading the view.
    
    [self addToolBar];
}

#pragma mark initNavigationBar

- (void)initNavigationBar {
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)setCollectionView {
    
    //the number of images in one line
    NSInteger numberOfColum = 4;
    //the flowLayout for collectionView
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing=5;
    layout.minimumInteritemSpacing=5;
    layout.sectionInset=UIEdgeInsetsMake(5,5,5,5);
    CGFloat itemWidth = (self.view.bounds.size.width*1.0-(numberOfColum+1)*5)/numberOfColum;
    layout.itemSize=CGSizeMake(itemWidth,itemWidth);
    //the collection to display images
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height-44) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.alwaysBounceVertical=YES;
    
    // Register cell classes
    [_collectionView registerClass:[QPImageCell class] forCellWithReuseIdentifier:reuseIdentifier];

}

#pragma mark optimized selectors

- (void)addToolBar {
    
    _toolBar=[[QPToolBar alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -44 ,self.view.frame.size.width,44)];
    _toolBar.delegate=self;
    _toolBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_toolBar];
    
    _toolBar.selectedCount=_selectPhotoModels.count;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _albumModel.photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QPImageCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    QPPhoto* photoModel = _albumModel.photoModels[indexPath.item];
    cell.model=photoModel;
    // Configure the cell
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QPPreViewViewController* previewController = [[QPPreViewViewController alloc] init];
    previewController.delegate=_delegate;
    previewController.photoSelectDelegate=self;
    previewController.currentIndex=indexPath.row;
    previewController.photoModels=_albumModel.photoModels;
    previewController.selectedPhotoModels=_selectPhotoModels;
    [self.navigationController pushViewController:previewController animated:YES];
}

#pragma mark QPImageCellDelegate Mathods

- (void)selectImageWithCell:(QPImageCell *)cell
{
    NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
    QPPhoto* photoModel = _albumModel.photoModels[indexPath.item];
    
    if (_selectPhotoModels.count == _maxCanSelectdCount && !photoModel.selected) return;
   
    photoModel.selected=!photoModel.selected;
    cell.isSelected=photoModel.selected;
    
    if (cell.isSelected) {
        [_selectPhotoModels addObject:photoModel];
    }else
        [_selectPhotoModels removeObject:photoModel];
    _toolBar.selectedCount=_selectPhotoModels.count;
}

#pragma mark QPToolBarDelegate Methods

- (void)selectDone
{
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImages:andImageAssets:)]) {
        [(id<QPImagePickerViewControllerDelegate>)_delegate imagePickerController:(QPImagePickerViewController*)self.navigationController didFinishPickingMediaWithImages:[[QPImagePickerDataSourceManager sharedInstance] requestImagesWithPhotoModels:_selectPhotoModels] andImageAssets:[[QPImagePickerDataSourceManager sharedInstance] requestImageAssetsWithPhotoModels:_selectPhotoModels]];
    }
}

- (void)lookAtPhotos
{
    QPPreViewViewController* previewController = [[QPPreViewViewController alloc] init];
    previewController.photoSelectDelegate=self;
    previewController.delegate=_delegate;
    previewController.photoModels=[_selectPhotoModels mutableCopy];
    previewController.selectedPhotoModels=_selectPhotoModels;
    [self.navigationController pushViewController:previewController animated:YES];
}

#pragma mark QPPhotosViewControllerDelegate

- (void)photoSelectedWithPhotoModel:(QPPhoto *)photoModel
{
    _toolBar.selectedCount=_selectPhotoModels.count;
    [_collectionView reloadData];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
