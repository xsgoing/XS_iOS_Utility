//
//  XSQRView.h
//  原生二维码扫描
//
//  Created by 肖胜 on 15/11/12.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface XSQRView : UIView<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,copy) void(^block)(NSString *url);
@end
