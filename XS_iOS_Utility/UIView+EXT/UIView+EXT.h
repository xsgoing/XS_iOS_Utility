//
//  UIView+EXT.h
//  Movie2
//
//  Created by student on 15-2-9.
//  Copyright (c) 2015年 student. All rights reserved.
//


//类目文件，用于对控件的frame进行操作
#import <UIKit/UIKit.h>

@interface UIView (EXT)
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGPoint origin;//原点
@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat right;
@property (nonatomic,assign)CGFloat bottom;
@end
