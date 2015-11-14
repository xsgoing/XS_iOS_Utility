//
//  XSFollowView.m
//  MasonryExe
//
//  Created by 肖胜 on 15/11/13.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "XSFollowView.h"
#import "UIView+EXT.h"

@implementation XSFollowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        self.userInteractionEnabled = YES;
        self.direction = XSFollowViewMoveDirectionDefault;
        [self addGestureRecognizer:pan];
    }
    return self;
}



// 移动
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
     /**
     *  如果为给定限制区域，则为父视图区域
     */
    if (_limitRect.size.width == 0) {
        _limitRect = self.superview.bounds;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        if ([_delegate respondsToSelector:@selector(followViewBeginMove:)]) {
            
            [_delegate followViewBeginMove:self];
        }
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if ([_delegate respondsToSelector:@selector(followViewMoving:)]) {
            
            [_delegate followViewMoving:self];
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if ([_delegate respondsToSelector:@selector(followViewStop:)]) {
            
            [_delegate followViewStop:self];
        }
    }
    
    CGFloat X = 0.0;
    CGFloat Y = 0.0;
    CGPoint translatedPoint = [pan translationInView:pan.view.superview];
    if (_direction == XSFollowViewMoveDirectionDefault) {
        
        Y = pan.view.center.y + translatedPoint.y;
        X = pan.view.center.x + translatedPoint.x;
    }
    if (_direction == XSFollowViewMoveDirectionHorizontal) {
        
        Y = pan.view.center.y;
        X = pan.view.center.x + translatedPoint.x;
    }
    if (_direction == XSFollowViewMoveDirectionVertical) {
        
        Y = pan.view.center.y + translatedPoint.y;
        X = pan.view.center.x;
    }
    pan.view.center = CGPointMake(X, Y);
    if (!_canMoveOut) {
        
        if (pan.view.x <= _limitRect.origin.x) {
            
            pan.view.x = _limitRect.origin.x;
        }
        if (pan.view.right >= _limitRect.size.width) {
            
            pan.view.right = _limitRect.size.width;
        }
        if (pan.view.y <= _limitRect.origin.y) {
            
            pan.view.y =  _limitRect.origin.y;
        }
        if (pan.view.bottom >= _limitRect.size.height) {
            
            pan.view.bottom = _limitRect.size.height;
        }
    }
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view.superview];
    
}


@end
