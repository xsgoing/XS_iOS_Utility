//
//  XSFollowView.h
//  MasonryExe
//
//  Created by 肖胜 on 15/11/13.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XSFollowViewMoveDirection) {
    
    XSFollowViewMoveDirectionDefault = 0,
    XSFollowViewMoveDirectionHorizontal = 1,
    XSFollowViewMoveDirectionVertical = 2
    
};

 
@class XSFollowView;
@protocol XSFollowViewDelegate <NSObject>
@optional

/**
 *  视图开始移动
 *
 *  @param followView XSFollowView
 */
- (void)followViewBeginMove:(XSFollowView *)followView;

/**
 *  视图移动中
 *
 *  @param followView XSFollowView
 */
- (void)followViewMoving:(XSFollowView *)followView;

/**
 *  视图停止移动
 *
 *  @param followView XSFollowView
 */
- (void)followViewStop:(XSFollowView *)followView;

@end
#import <UIKit/UIKit.h>
@interface XSFollowView : UIImageView

/**
 *  是否能移出父视图
 */
@property (nonatomic,assign)BOOL canMoveOut;
/**
 *  视图能移动的方向
 */
@property (nonatomic,assign)XSFollowViewMoveDirection direction;
@property (nonatomic,assign)id <XSFollowViewDelegate> delegate;
/**
 *  限制区域
 */
@property (nonatomic,assign)CGRect limitRect;
@end
