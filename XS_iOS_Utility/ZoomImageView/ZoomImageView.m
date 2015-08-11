//
//  ZoomImageView.m
//  XSWeibo
//
//  Created by student on 15-4-13.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import "ZoomImageView.h"
//#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
//#import "MBProgressHUD.h"
#import "UIView+EXT.h"
@implementation ZoomImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _init];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    
    self = [super initWithImage:image];
    if (self) {
        
        [self _init];
    }
    return self;
}

// 初始化，给视图添加手势
- (void)_init {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
}



// 创建视图
- (void)_createViews {
    
    // 滑动视图
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.y = 20.f;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self.window addSubview:_scrollView];
    }

    // 大图片视图
    if (_fullImageView == nil) {
        
        _fullImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
    }
    
    // 加载进度视图
    _progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progress.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.bounds), 5);
    [_scrollView addSubview:_progress];
    
    // 添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOut)];
    [_scrollView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImg:)];
    longPress.minimumPressDuration = 2;
    [_scrollView addGestureRecognizer:longPress];
}

// 放大
- (void)zoomIn {
    
    if ([_delegate respondsToSelector:@selector(zoomImageViewWillZoomIn)]) {
        
        [_delegate zoomImageViewWillZoomIn];
    }
    
    // 创建放大视图
    [self _createViews];
    
    self.hidden = YES;
    
    // 放大图片的动画
    // 坐标转换：当前视图的坐标(x1,y1) --> 在window上显示的(x2,y2)
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    _fullImageView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _fullImageView.frame = _scrollView.bounds;
    }completion:^(BOOL finished) {
        
        if ([_delegate respondsToSelector:@selector(zoomImageViewDidZoomIn)]) {
            
            [_delegate zoomImageViewWillZoomIn];
        }
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    }];
    
    // 如果有大图地址加载网络
    if (_urlString != nil) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        
        _imgData = [[NSMutableData alloc]init];
        
        // 发送异步请求网络
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    // 没有大图地址
    else {
        // 如果原图是长图
        CGFloat height = self.image.size.height/self.image.size.width * _scrollView.frame.size.width;
        if (height > _scrollView.frame.size.height) {
            
            CGRect frame = _fullImageView.frame;
            frame.size.height = height;
            _fullImageView.frame = frame;
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
        }
    }
}

// 缩小
- (void)zoomOut {
    
    if ([_delegate respondsToSelector:@selector(zoomImageViewWillZoomOut)]) {
        
        [_delegate zoomImageViewWillZoomOut];
    }
    
    //坐标转换，设置缩小后的frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _scrollView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
       
        _fullImageView.frame = frame;
    } completion:^(BOOL finished) {
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _progress = nil;
        self.hidden = NO;
        
        if ([_delegate respondsToSelector:@selector(zoomImageViewDidZoomOut)]) {
            
            [_delegate zoomImageViewDidZoomOut];
        }
    }];
}

// 长按保存图片到相册
- (void)saveImg:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIImage *img = [UIImage imageWithData:_imgData];
        if (img != nil) {
            
            // 保存提示
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
//            hud.labelText = @"正在保存";
//            hud.dimBackground = YES;
//            // 图片保存到相册
//            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
        }
    }
    
}

// 保存图片完成调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    // 完成提示
//    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
//    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.labelText = @"保存成功";
//    
//    [hud hide:YES afterDelay:1.4];
}

#pragma mark - NSURLConnectionDataDelegate
// 服务器响应的事件
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *allFields = [httpResponse allHeaderFields];
    
    // 取得数据长度
    NSString *size = allFields[@"Content-Length"];
    _length = [size doubleValue];
}

// 接受数据包
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_imgData appendData:data];
    CGFloat progress = _imgData.length/_length;
    _progress.progress = progress;
}

// 数据加载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // 显示已加载的图片
    UIImage *image = [UIImage imageWithData:_imgData];
    _fullImageView.image = image;
    _progress.progress = 1;
    _progress.hidden = YES;
    
    // 处理长图
    CGFloat height = image.size.height/image.size.width * _scrollView.frame.size.width;
    if (height > _scrollView.frame.size.height) {
        
        CGRect frame = _fullImageView.frame;
        frame.size.height = height;
        _fullImageView.frame = frame;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
    }

    
    // 处理gif图片
    // 获取扩展名
    NSString *extension = [self.urlString pathExtension];
    if ([extension isEqualToString:@"gif"]) {
        
        // 1.SDWebImage框架实现
        //_fullImageView.image = [UIImage sd_animatedGIFWithData:_imgData];
        
        // 2.webView播放
        /*
        UIWebView *webView = [[UIWebView alloc]initWithFrame:_scrollView.bounds];
        webView.userInteractionEnabled = NO;
        webView.scalesPageToFit = YES;
        [webView loadData:_imgData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [_scrollView addSubview:webView];
        */
        
        //3. 使用ImageIO提取gif图片中所有帧的图片进行播放
        // 创建图片原源
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_imgData, NULL);
        
        // 获取图片源中图片的个数
        size_t count = CGImageSourceGetCount(source);
        NSMutableArray *images = [NSMutableArray array];
        
        for (int i = 0; i < count; i++) {
            
            // 从图片源中取图片
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            [images addObject:[UIImage imageWithCGImage:image]];
            
            // 释放
            CGImageRelease(image);
        }
        
        // 实现1..将图片拼成动画
        UIImage *imgs = [UIImage animatedImageWithImages:images duration:count * 0.1];
        _fullImageView.image = imgs;
       
        // 实现2..将图片数组直接赋给imageView
        /*
        _fullImageView.animationImages = images;
        _fullImageView.animationDuration = count * 0.1;
        [_fullImageView startAnimating];
         */
    }
 
}
@end

