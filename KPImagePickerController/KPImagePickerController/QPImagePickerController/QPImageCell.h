//
//  QPImageCell.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPAlbum.h"

@class QPImageCell;

@protocol QPImageCellDelegate <NSObject>
@optional
- (void)selectImageWithCell:(QPImageCell*)cell;
@end

//the custom cell for UICollectionViewCell

@interface QPImageCell : UICollectionViewCell <QPImageCellDelegate>
{
    UIImageView* _imageView; //the imageView to display images
    UIButton* _statusButton; //the status is use for check be selected
}
@property (nonatomic,retain)UIImage* image;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,retain)QPPhoto* model;
@property (nonatomic,assign)id<QPImageCellDelegate> delegate;
@end
