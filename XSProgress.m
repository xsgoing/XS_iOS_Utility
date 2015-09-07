//
//  XSProgress.m
//  XS_iOS_Utility
//
//  Created by 肖胜 on 15/9/1.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "XSProgress.h"

static XSProgress *instace = nil;
static int i;
NSTimer *timer;
@implementation XSProgress

+ (XSProgress *)shareInstace {
    
    
    if (instace == nil) {
        
        instace = [[self alloc]init];
    }

     return instace;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (instace == nil) {
        
        instace = [super allocWithZone:zone];
    }
    return instace;
}


+ (void)show {
 
    instace = [self shareInstace];
    instace.frame = CGRectMake(100, 350, 100, 100);
    instace.alpha = 0;
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:.5 animations:^{
       
        instace.alpha = 1;
    }];
    [keywindow addSubview:instace];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(annimation) userInfo:nil repeats:YES];
    
}

+(void)hide {
    
    [UIView animateWithDuration:.5 animations:^{
        instace.alpha = 0;
    } completion:^(BOOL finished) {
        
        [instace removeFromSuperview];
        [timer invalidate];
        timer = nil;
        instace = nil;
    }];
}

+ (void)annimation {
    
    i++;
    instace.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
    if (i == 3) {
        i = 0;
    }
}
@end
