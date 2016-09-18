//
//  QPPreViewViewController.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPPreViewViewController.h"
#import "QPPreViewCell.h"
#import "QPToolBar.h"
#import "QPImagePickerDataSourceManager.h"

@interface QPPreViewViewController () <QPPreViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton* _rightBarButton;   //navigationBar right button
    UIView* _bottomView; //bottom view
    UIButton* _countButton; //display selected count button
    UIButton* _doneButton; //done button
    UICollectionView* _collectionView;
}
@end

@implementation QPPreViewViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initNavigationBar];
    [self addCollectionView];
    [self addBottomView];
}

#pragma mark initNavigationBar

- (void)initNavigationBar {
    
    UIView* buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    buttonBackView.backgroundColor=[UIColor clearColor];
    
    _rightBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
    _rightBarButton.frame=CGRectMake(0,0,30,30);
    [_rightBarButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [buttonBackView addSubview:_rightBarButton];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buttonBackView];
}

#pragma mark setCollectionView

- (void)addCollectionView {
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset=UIEdgeInsetsMake(0,0,0,0);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize=CGSizeMake(self.view.bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor blackColor];
    _collectionView.pagingEnabled=YES;
    [self.view addSubview:_collectionView];
    
    // Register cell classes
    [_collectionView registerClass:[QPPreViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [_collectionView setContentOffset:CGPointMake(_currentIndex*self.view.bounds.size.width,0)];
    [self checkCurrentPhotoStatusWithIndex:_currentIndex];
}

#pragma mark addBottomView

- (void)addBottomView {
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-44,self.view.bounds.size.width,44)];
    _bottomView.backgroundColor=[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1.0];
    [self.view addSubview:_bottomView];
    
    _countButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _countButton.frame=CGRectMake(self.view.frame.size.width-64,10,24,24);
    _countButton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [_countButton setBackgroundImage:[UIImage imageNamed:@"photo_number_icon"] forState:UIControlStateNormal];
    _countButton.hidden=YES;
    [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_countButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_countButton];
    
    _doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame=CGRectMake(self.view.frame.size.width-50,0,50,44);
    _doneButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_doneButton];

    [self setBottomStatus];
}

#pragma mark selectors

- (void)selectImage {
    
    NSInteger currentIndex = _collectionView.contentOffset.x / self.view.bounds.size.width;
    QPPhoto* photo = _photoModels[currentIndex];
    
    if (photo.selected) {
        photo.selected=NO;
        [_selectedPhotoModels removeObject:photo];
    }else{
        [_selectedPhotoModels addObject:photo];
        [UIView animateWithDuration:0.15 delay:0.0f options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [_countButton.layer setValue:@(1.15) forKeyPath:@"transform.scale"];
            [_rightBarButton.layer setValue:@(1.15) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_countButton.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
                    [_rightBarButton.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                    if (finished) {
                        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [_rightBarButton.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                            [_countButton.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                        } completion:nil];
                    }
                }];
            }
        }];
        photo.selected=YES;
    }
    [self checkCurrentPhotoStatusWithIndex:currentIndex];
    
    //reset the bottom state
    
    [self setBottomStatus];
    
    /*
     Informed before an interface to refresh the data
     */
    if ([_photoSelectDelegate respondsToSelector:@selector(photoSelectedWithPhotoModel:)])
        [_photoSelectDelegate photoSelectedWithPhotoModel:photo];

}

- (void)setBottomStatus {
    
    if (_selectedPhotoModels.count == 0) {
        _countButton.hidden=YES;
        _doneButton.enabled=NO;
    }else{
        _countButton.hidden=NO;
        _doneButton.enabled=YES;
        [_countButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotoModels.count] forState:UIControlStateNormal];
    }

}

- (void)checkCurrentPhotoStatusWithIndex:(NSInteger)index {
    
    QPPhoto* photo = _photoModels[index];
    if (photo.selected)
        [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
    else
        [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
}

- (void)done {
    
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImages:andImageAssets:)]) {
        [(id<QPImagePickerViewControllerDelegate>)_delegate imagePickerController:(QPImagePickerViewController*)self.navigationController didFinishPickingMediaWithImages:[[QPImagePickerDataSourceManager sharedInstance] requestImagesWithPhotoModels:_selectedPhotoModels] andImageAssets:[[QPImagePickerDataSourceManager sharedInstance] requestImageAssetsWithPhotoModels:_selectedPhotoModels]];
    }
}

- (void)clickImageWithCell:(QPPreViewCell *)cell
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y > 0)
        frame.origin.y = -frame.size.height;
    else
        frame.origin.y = 20;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.navigationController.navigationBar.frame=frame;
    } completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QPPreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.delegate=self;
    cell.photoModel = _photoModels[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / self.view.bounds.size.width;
    [self checkCurrentPhotoStatusWithIndex:currentIndex];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y != 20) {
        frame.origin.y = 20;
        self.navigationController.navigationBar.frame=frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
