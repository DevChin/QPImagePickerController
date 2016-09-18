//
//  QPImagePickerDataSourceManager.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^requestCompletionHandle)(UIImage * result, NSDictionary * info);

@interface QPImagePickerDataSourceManager : NSObject
//the singleton
+ (instancetype)sharedInstance;
// get all albums from phone
- (PHFetchResult*)albums;
- (PHFetchResult*)userAlbums;
//get assets from album
- (PHFetchResult*)assetsInCollection:(PHAssetCollection*)collection;
//get image with asset
- (PHImageRequestID)requestLargeImageWithAsset:(PHAsset*)asset andCompletionHandle:(requestCompletionHandle)resultHandle;
//the thumbnial image of asset
- (PHImageRequestID)requestThumbnailImageWithAsset:(PHAsset*)asset andThumbnailSize:(CGSize)size andCompletionHandle:(requestCompletionHandle)resultHandle;
- (NSArray*)requestImagesWithPhotoModels:(NSArray*)photoModels;
- (NSArray*)requestImageAssetsWithPhotoModels:(NSArray*)photoModels;
@end
