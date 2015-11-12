//
//  XSQRView.m
//  原生二维码扫描
//
//  Created by 肖胜 on 15/11/12.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "XSQRView.h"

#define ScreenHigh     [UIScreen mainScreen].bounds.size.height
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
AVCaptureDevice *_device;
AVCaptureDeviceInput *_input;
AVCaptureMetadataOutput *_output;
AVCaptureSession *_session;
AVCaptureVideoPreviewLayer *_preview;
UIImageView *lineImg;
BOOL isUp;

@implementation XSQRView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:_input]) {
            
            [_session addInput:_input];
        }
        if ([_session canAddOutput:_output]) {
            
            [_session addOutput:_output];
        }
        
        // 扫描类型
        _output.metadataObjectTypes = _output.availableMetadataObjectTypes;
        
        // 扫描区域限制
        [_output setRectOfInterest:CGRectMake((124.0)/ScreenHigh,((ScreenWidth-220)/2.0)/ScreenWidth,220.0/ScreenHigh,220.0/ScreenWidth)];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-220)/2.0, 124, 220, 220)];
        img.image = [UIImage imageNamed:@"zbar_pick_bg"];
        [self addSubview:img];
        
        lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, img.frame.size.width, 3)];
        lineImg.image = [UIImage imageNamed:@"zbar_line"];
        [img addSubview:lineImg];
        
        [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 124)];
        view1.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view1];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), (ScreenWidth-220)/2.0, 220)];
        view2.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view2];
        
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame),  self.frame.size.width, ScreenHigh- CGRectGetMaxY(view2.frame))];
        view3.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view3];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, view3.frame.size.width, 20)];
        title.text = @"将二维码/条形码放入框中,即可自动扫描";
        title.font = [UIFont systemFontOfSize:12];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor greenColor];
        [view3 addSubview:title];
        
        UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame), CGRectGetMaxY(view1.frame),  view2.frame.size.width, view2.frame.size.height)];
        view4.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view4];
        
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResize;
        _preview.backgroundColor = [UIColor blackColor].CGColor;
        _preview.frame = self.layer.bounds;
        [self.layer insertSublayer:_preview atIndex:0];
        
        [_session startRunning];

    }
    return self;
}

// 横线移动
- (void)timeAction:(NSTimer *)timer {
    
    
    CGRect frame = lineImg.frame;
    if (isUp) {
        frame.origin.y --;
    }
    else {
        frame.origin.y ++;
    }
    if (frame.origin.y == 210) {
        isUp = YES;
    }
    if (frame.origin.y == 10) {
        
        isUp = NO;
    }
    lineImg.frame = frame;
    
}


- (void)setBlock:(void (^)(NSString *))block {
    
    if (_block != block) {
        
        _block = block;
    }
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] >0)
        
    {

        //停止扫描
        
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        NSString *stringValue = [metadataObject stringValue];
        
        if (_block != nil) {
            
            _block(stringValue);
        }
    }
}


@end
