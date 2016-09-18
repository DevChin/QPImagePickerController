//
//  QPImagePickerDataSourceManager.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPImagePickerDataSourceManager.h"
#import "QPAlbum.h"

@implementation QPImagePickerDataSourceManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QPImagePickerDataSourceManager* manager;
    dispatch_once(&onceToken, ^{
        manager=[[QPImagePickerDataSourceManager alloc] init];
    });
    return manager;
}

- (PHFetchResult*)albums
{
    // the  condition of albums
    PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    return result;
}

- (PHFetchResult*)userAlbums
{
    // the  condition of  user created albums
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    return topLevelUserCollections;
}

- (PHFetchResult*)assetsInCollection:(PHAssetCollection*)collection {
    PHFetchResult* result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    return result;
}

- (PHImageRequestID)requestLargeImageWithAsset:(PHAsset *)asset andCompletionHandle:(void (^)(UIImage * _Nullable, NSDictionary * _Nullable))resultHandle
{
    //获取原图尺寸和质量图片
    PHImageRequestOptions* options=[[PHImageRequestOptions alloc] init];
    options.resizeMode=PHImageRequestOptionsResizeModeExact;
    options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageRequestID requestId=[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth,asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:resultHandle];
    return requestId;
}

- (PHImageRequestID)requestThumbnailImageWithAsset:(PHAsset *)asset andThumbnailSize:(CGSize)size andCompletionHandle:(requestCompletionHandle)resultHandle
{
    PHImageRequestOptions* options=[[PHImageRequestOptions alloc] init];
    options.resizeMode=PHImageRequestOptionsResizeModeFast;
    PHImageRequestID requestId=[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(size.width*[UIScreen mainScreen].scale,size.height*[UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:options resultHandler:resultHandle];
    return requestId;
}

- (NSArray*)requestImagesWithPhotoModels:(NSArray*)photoModels {
    
    NSMutableArray* images=[[NSMutableArray alloc] init];
    
    for (QPPhoto* photo in photoModels) {
        
        CGFloat width = ( [UIScreen mainScreen].bounds.size.width - 25 ) / 4 * [UIScreen mainScreen].scale;
        
        [[QPImagePickerDataSourceManager sharedInstance] requestThumbnailImageWithAsset:photo.imageAsset andThumbnailSize:CGSizeMake(width,width) andCompletionHandle:^(UIImage *result, NSDictionary *info) {
            if (result)
            [images addObject:result];
        }];
    }
    return [images copy];
}

- (NSArray*)requestImageAssetsWithPhotoModels:(NSArray *)photoModels
{
    NSMutableArray* imageAssets=[[NSMutableArray alloc] init];
    for (QPPhoto* photo in photoModels) {
        [imageAssets addObject:photo.imageAsset];
    }
    return [imageAssets copy];
}
@end
