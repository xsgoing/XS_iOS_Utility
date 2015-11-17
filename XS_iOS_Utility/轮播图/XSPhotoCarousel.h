//
//  XSPhotoCarousel.h
//  MasonryExe
//
//  Created by 肖胜 on 15/11/14.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//
/**
 *  图片轮播
 */
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ImageTypeUrlString = 0,
    ImageTypeLocalPath = 1,
    ImageTypeImage =2,
} ImageType;

@interface XSPhotoCarousel : UIView<UIScrollViewDelegate>
@property (nonatomic,assign)void(^block)(NSInteger index);
/**
 *  创建轮播图
 *
 *  @param frame      frame
 *  @param images     图片数组
 *  @param imageType  数组中元素类型
 *  @param autoScroll 是否自动滚动
 *  @param image      默认图片
 *  @return 轮播图
 */
- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images ImageType:(ImageType)imageType AutoScroll:(BOOL)autoScroll placeImg:(UIImage *)image;


@end
