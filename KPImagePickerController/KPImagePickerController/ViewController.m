//
//  ViewController.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/15.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "ViewController.h"
#import "QPImagePickerViewController.h"
#import "QPImagePickerDataSourceManager.h"

@interface SelectImageCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView* imageView;
@end

@implementation SelectImageCell

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
      
        self.contentView.backgroundColor=[UIColor whiteColor];
        _imageView=[[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,QPImagePickerViewControllerDelegate>
{
    UICollectionView* _collectionView; // the colectionView to display selectedImages
    NSMutableArray* _selectedImages; //the array of selectedImages
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedImages=[[NSMutableArray alloc] init];
    self.navigationItem.title=@"图片选择Demo";
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpContentView];
}

#pragma mark - setUpContentViews

- (void)setUpContentView {

    //the number of images in one line
    NSInteger numberOfColum = 4;
    //the flowLayout for collectionView
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing=5;
    layout.minimumInteritemSpacing=5;
    layout.sectionInset=UIEdgeInsetsMake(5,5,5,5);
    layout.itemSize=CGSizeMake((self.view.bounds.size.width*1.0-(numberOfColum+1)*5)/numberOfColum,(self.view.bounds.size.width*1.0-(numberOfColum+1)*5)/numberOfColum);
    //the collection to display images
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SelectImageCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDelegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedImages.count+1;
}

#pragma mark - UICollectionViewDatasource Methods

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    SelectImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_selectedImages.count == indexPath.item) {
        cell.imageView.image=[UIImage imageNamed:@"AlbumAddBtn"];
        cell.backgroundColor=[UIColor redColor];
    }else{
        
        [[QPImagePickerDataSourceManager sharedInstance] requestThumbnailImageWithAsset:_selectedImages[indexPath.item] andThumbnailSize:cell.contentView.bounds.size andCompletionHandle:^(UIImage *result, NSDictionary *info) {
            if (result)
                cell.imageView.image=result;
        }];
      
        //cell.imageView.image = _selectedImages[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedImages.count == indexPath.item) {
        
        // IOS 8.0 later
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"图片选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // do something when click the action button ...
            
            
            
            
            
            
        }];
        
        UIAlertAction* libiaryAction = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // do something when click the action button ...
            QPImagePickerViewController* picker = [[QPImagePickerViewController alloc] init];
            picker.delegate=self;
            picker.maxCanSelectdCount=2;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:libiaryAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
}

#pragma mark QPImagePickerViewControllerDelegate

- (void)imagePickerController:(QPImagePickerViewController *)picker didFinishPickingMediaWithImages:(NSArray<UIImage *> *)images andImageAssets:(NSArray<PHAsset *> *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_selectedImages addObjectsFromArray:assets];
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
