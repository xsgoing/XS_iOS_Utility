//
//  DataService.m
//  XSWeibo
//
//  Created by student on 15-4-13.
//  Copyright (c) 2015年 student. All rights reserved.
//

#import "DataService.h"

@implementation DataService
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                            httpMethod:(NSString *)method
                               timeout:(NSTimeInterval)time
                                params:(NSDictionary *)params
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                            completion:(void(^)(id result,NSError *error))block {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = time;
    if (responseSerializer == nil) {
        
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    manager.responseSerializer = responseSerializer;
    AFHTTPRequestOperation *operation = nil;
    
    // GET请求
    if ([method isEqualToString:@"GET"]) {
        
        operation = [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 回调block
            if (block != nil) {
                
                block(responseObject,nil);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 错误提示

            if (block != nil) {
                
                block(nil,error);
            }
        }];
    }
    // POST请求
    else if ([method isEqualToString:@"POST"]){
        
               // 无图片，音频、视频
            operation = [manager POST: urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // 回调block
                if (block != nil) {
                    
                    block(responseObject,nil);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                

                if (block != nil) {
                    
                    block(nil,error);
                }
            }];
        }
        
    return operation;
    

}

/**
 *  方法描述
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
                            completion:(void(^)(id result,NSError *error))block {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = time;
    manager.responseSerializer = responseSerializer;
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data
                                            name:@"pic"
                                        fileName:@"rich.jpg"
                                        mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 回调block
        if (block != nil) {
            
            block(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        block(nil,error);
    }];

    return operation;
}

+ (void)checkNetWork:(void (^)(AFNetworkReachabilityStatus))block{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        block(status);
    }];
}
@end
