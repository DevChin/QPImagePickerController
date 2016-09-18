//
//  QPPreViewViewController.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPImagePickerViewController.h"
#import "QPPhotosViewController.h"

@interface QPPreViewViewController : UIViewController <QPImagePickerViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,retain)NSArray* photoModels;
@property (nonatomic,retain)NSMutableArray* selectedPhotoModels;  //selected models

// scroll to currentIndex
@property (nonatomic,assign)NSInteger currentIndex;
// the delegate to select photoModels in PreviewController
@property (nonatomic,assign)id<QPPhotosViewControllerDelegate> photoSelectDelegate;
@property (nonatomic,assign)id<QPImagePickerViewControllerDelegate,UINavigationControllerDelegate> delegate;
@end
