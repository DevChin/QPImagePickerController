//
//  QPAlbum.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPAlbum.h"

@implementation QPAlbum
- (id)init
{
    if (self=[super init]) {
        self.selectedModels=[[NSMutableArray alloc] init];
        self.photoModels=[[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation QPPhoto

@end
