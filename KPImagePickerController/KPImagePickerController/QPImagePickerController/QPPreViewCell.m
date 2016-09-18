//
//  QPPreViewCell.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPPreViewCell.h"
#import "QPImagePickerDataSourceManager.h"

@interface QPPreViewCell () <UIScrollViewDelegate>
{
   UIScrollView *_scrollView;
   UIImageView *_imageView;
}

@end

@implementation QPPreViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.contentView.bounds;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self.contentView addSubview:_scrollView];
        
    
        _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.clipsToBounds = YES;
        [_scrollView addSubview:_imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
    }
    return self;
}

#pragma mark setters

- (void)setPhotoModel:(QPPhoto *)photoModel
{
    _photoModel=photoModel;
    [_scrollView setZoomScale:1.0 animated:NO];
    
    CGSize imageSize = CGSizeMake(_photoModel.imageAsset.pixelWidth*1.0/[UIScreen mainScreen].scale, _photoModel.imageAsset.pixelHeight*1.0/[UIScreen mainScreen].scale);
    CGFloat scale = MAX(imageSize.width / self.contentView.bounds.size.width, imageSize.height / self.contentView.bounds.size.height);
    _imageView.frame=CGRectMake(self.contentView.bounds.size.width/2-imageSize.width/scale/2,self.contentView.bounds.size.height/2-imageSize.height/scale/2,imageSize.width/scale,imageSize.height/scale);
    [[QPImagePickerDataSourceManager sharedInstance] requestThumbnailImageWithAsset:_photoModel.imageAsset andThumbnailSize:CGSizeMake(imageSize.width/scale,imageSize.height/scale) andCompletionHandle:^(UIImage *result, NSDictionary *info) {
        if (result) {
            _imageView.image=result;
        }
    }];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:_imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(clickImageWithCell:)])
        [_delegate clickImageWithCell:self];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
