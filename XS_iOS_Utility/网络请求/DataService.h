//
//  DataService.h
//  XSWeibo
//
//  Created by student on 15-4-13.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

@interface DataService : NSObject
/**
 *  AFN网络请求
 *
 *  @param urlString          访问的url
 *  @param method             访问方式
 *  @param time               超时时间
 *  @param params             参数
 *  @param responseSerializer 返回值类型
 *  @param block              返回值后回调
 *
 *  @return return value description
 */
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                            httpMethod:(NSString *)method
                               timeout:(NSTimeInterval)time
                                params:(NSDictionary *)params
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                            completion:(void(^)(id result,NSError *error))block;
/**
 *  AFN文件上传
 *
 *  @param urlString          访问的url
 *  @param method             访问方式
 *  @param time               超时时间
 *  @param params             参数
 *  @param data               文件
 *  @param responseSerializer 返回值参数
 *  @param block              返回值后回调
 *
 *  @return return value description
 */
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                            httpMethod:(NSString *)method
                               timeout:(NSTimeInterval)time
                                params:(NSDictionary *)params
                              fileData:(NSData *)data
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                            completion:(void(^)(id result,NSError *error))block;

/**
 *  AFN监听网络状态
 *
 *  @param block 回调网络状态 
 */
+ (void)checkNetWork:(void(^)(AFNetworkReachabilityStatus status))block;
@end
