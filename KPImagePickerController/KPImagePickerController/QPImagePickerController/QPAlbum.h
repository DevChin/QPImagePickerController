//
//  QPAlbum.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface QPAlbum : NSObject
@property (nonatomic,retain)NSString* name;
@property (nonatomic,retain)PHAsset* thumbnailAsset;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,retain)NSMutableArray* photoModels;
@property (nonatomic,retain)NSMutableArray* selectedModels;
@end

@interface QPPhoto : NSObject
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,retain)PHAsset* imageAsset;
@end



