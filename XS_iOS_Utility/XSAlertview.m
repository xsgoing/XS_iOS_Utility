//
//  XSAlertview.m
//  XS_iOS_Utility
//
//  Created by 肖胜 on 15/11/9.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "XSAlertview.h"

XSAlertview *instance = nil;
BOOL isShow;
UILabel *textLabel;
@implementation XSAlertview

+(id)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[XSAlertview alloc]init];
        instance.frame = CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 40);
        instance.backgroundColor = [UIColor colorWithRed:0.537f green:0.729f blue:0.969f alpha:1.00f];
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, instance.frame.size.width, instance.frame.size.height)];
        [instance addSubview:textLabel];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
        instance.windowLevel = UIWindowLevelAlert;
        instance.hidden = NO;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}


+(void)showWithMessage:(NSString *)message BackGroungColor:(UIColor *)backColor TitleColor:(UIColor *)titleColor {
    
    if (isShow) {
        return;
    }
    instance = [self shareInstance];
    textLabel.text = message;
    if (backColor != nil) {
        
        instance.backgroundColor = backColor;
    }
    if (titleColor != nil) {
        
        textLabel.textColor = titleColor;
    }
    [UIView animateWithDuration:.5 animations:^{
        isShow = YES;
        instance.transform = CGAffineTransformMakeTranslation(0, 40);
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            instance.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            
            isShow = NO;
        }];
    }];
}
@end
