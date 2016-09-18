//
//  QPPhotosViewController.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPAlbum.h"
#import "QPImagePickerViewController.h"

@protocol QPPhotosViewControllerDelegate <NSObject>
@optional
- (void)photoSelectedWithPhotoModel:(QPPhoto*)photoModel;
@end

@interface QPPhotosViewController : UIViewController <QPImagePickerViewControllerDelegate,QPPhotosViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,assign)NSInteger maxCanSelectdCount;
@property (nonatomic,retain)QPAlbum* albumModel; // all models
@property (nonatomic,retain)NSMutableArray* selectPhotoModels; // selected models
@property (nonatomic,assign)id<QPImagePickerViewControllerDelegate,UINavigationControllerDelegate> delegate;
@end
