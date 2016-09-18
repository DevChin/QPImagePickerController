//
//  QPToolBar.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_COLOR [UIColor colorWithRed:31/255.0f green:185/255.0f blue:34/255.0f alpha:1.0]

@protocol QPToolBarDelegate <NSObject>
@optional
- (void)lookAtPhotos;
- (void)selectDone;
@end

@interface QPToolBar : UIView <QPToolBarDelegate>
@property (nonatomic,assign)NSInteger selectedCount;
@property (nonatomic,assign)id<QPToolBarDelegate> delegate;
@end
