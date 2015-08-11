//
//  ZoomImageView.h
//  XSWeibo
//
//  Created by student on 15-4-13.
//  Copyright (c) 2015年 student. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol ZoomImageViewDelegate <NSObject>

@optional
- (void)zoomImageViewWillZoomIn;
- (void)zoomImageViewWillZoomOut;
- (void)zoomImageViewDidZoomIn;
- (void)zoomImageViewDidZoomOut;
@end
#import <UIKit/UIKit.h>

@interface ZoomImageView : UIImageView <NSURLConnectionDataDelegate>{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_imgData;
    
    UIProgressView *_progress;

}
/**
 *  大图url
 */
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,weak)id<ZoomImageViewDelegate> delegate;
@end
