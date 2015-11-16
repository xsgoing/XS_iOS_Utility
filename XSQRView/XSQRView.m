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
CIDetector *_detector;
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
        _detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        
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
        
        // 上方
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 124)];
        view1.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view1];
        
        // 相册选择
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        albumBtn.frame = CGRectMake(view1.frame.size.width/4-10, view1.frame.size.height/2-10, 20, 20);
        [albumBtn setImage:[UIImage imageNamed:@"ablum"] forState:UIControlStateNormal];
        [view1 addSubview:albumBtn];
        [albumBtn addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lightBtn setImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateNormal];
        [lightBtn setImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateSelected];
        lightBtn.frame = CGRectMake(view1.frame.size.width/4*3-10, view1.frame.size.height/2-10, 20, 20);
        [lightBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:lightBtn];
        
        if (![_device hasFlash] || ![_device hasTorch]) {
            lightBtn.hidden = YES;
        }
        
        // 左边
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), (ScreenWidth-220)/2.0, 220)];
        view2.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view2];
        // 下方
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame),  self.frame.size.width, ScreenHigh- CGRectGetMaxY(view2.frame))];
        view3.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:view3];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, view3.frame.size.width, 20)];
        title.text = @"将二维码/条形码放入框中,即可自动扫描";
        title.font = [UIFont systemFontOfSize:12];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor greenColor];
        [view3 addSubview:title];
        // 右边
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

// 打开相册
- (void)choosePhoto {
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [[self getViewController] presentViewController:mediaUI animated:YES completion:^{
        
    }];
    
}

// 开关灯
- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


- (UIViewController *)getViewController {
    
    UIViewController *vc;
    UIResponder *next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {

        next = next.nextResponder;
    }
    if ([next isKindOfClass:[UIViewController class]]) {
        vc = (UIViewController *)next;
    }
    return vc;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSArray *_features = [_detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (_features != nil) {
        
        CIQRCodeFeature *featu = _features[0];
        NSString *result = featu.messageString;
        if (_block != nil) {
            
            _block(result);
        }

    }
    [picker dismissViewControllerAnimated:YES completion:nil];

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

        // 播放声音
        SystemSoundID soundID;
        NSString *path = [[NSBundle mainBundle]pathForResource:@"noticeMusic" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:path], &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        
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
