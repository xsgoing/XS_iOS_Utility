//
//  UIView+EXT.m
//  Movie2
//
//  Created by student on 15-2-9.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import "UIView+EXT.h"

@implementation UIView (EXT)


- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width {
    
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame= frame;
}
-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setX:(CGFloat)x  {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame= frame;
}
-(CGFloat)x {
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y  {
    
    CGRect frame = self.frame;
    frame.origin.y =y ;
    self.frame= frame;
}
-(CGFloat)y {
    return self.frame.origin.y;
}

-(void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setTop:(CGFloat)top {
    
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
-(CGFloat)top {
    return self.frame.origin.y;
}

-(void)setLeft:(CGFloat)left {
    
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
-(CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right-frame.size.width;
    self.frame =frame;
}

-(CGFloat)right {
    
    return self.frame.size.width +self.frame.origin.x;
}


- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom-frame.size.height;
    self.frame =frame;
    
}
- (CGFloat)bottom {
    
    return self.frame.size.height +self.frame.origin.y;
}
@end

