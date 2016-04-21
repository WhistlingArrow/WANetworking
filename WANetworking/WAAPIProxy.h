//
//  WAAPIProxy.h
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAURLResponse.h"

/**
 * 这个类封装了第三方网络库(这里用的AFNetworking3.0),当需要替换第三方网络库或AFN更新时直接修改这里就行
 * 由于AFN3.0废弃了AFHTTPRequestOperationManager,不能直接传入NSURLRequest,所以目前直接使用了AFHTTPSessionManager的POST、GET方法,导致封装不彻底---待研究~
 * 
 * 暂不支持HTTPS
 */
typedef void (^WAAPICallBack) (WAURLResponse *response);

@interface WAAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSUInteger)callPOSTWithUrlString:(NSString *)urlString
                            params:(NSDictionary *)params
                           success:(WAAPICallBack)success
                              fail:(WAAPICallBack)fail;
- (NSUInteger)callGETWithUrlString:(NSString *)urlString
                            params:(NSDictionary *)params
                           success:(WAAPICallBack)success
                              fail:(WAAPICallBack)fail;

- (void)cancelRequestWithRequestID:(NSUInteger)requestID;
- (void)cancelAllRequestImmediately;
- (void)cancelAllRequestAfterCurrentRequestsFinished;
- (BOOL)networkIsReachable;

@end
