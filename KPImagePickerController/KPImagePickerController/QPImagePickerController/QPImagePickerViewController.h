//
//  QPImagePickerViewController.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class QPImagePickerViewController;

@protocol QPImagePickerViewControllerDelegate <NSObject>
@optional
- (void)imagePickerController:(QPImagePickerViewController *)picker didFinishPickingMediaWithImages:(NSArray<UIImage*>*)images andImageAssets:(NSArray<PHAsset *> *)assets;
@end

@interface QPImagePickerViewController : UINavigationController <QPImagePickerViewControllerDelegate,UINavigationControllerDelegate>
// the maxinum selectable
@property (nonatomic,assign)NSInteger maxCanSelectdCount;
@property (nonatomic,assign)id<QPImagePickerViewControllerDelegate,UINavigationControllerDelegate> delegate;
@end
