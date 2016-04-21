//
//  WAAPIProxy.m
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import "WAAPIProxy.h"
#import "WAURLResponse.h"

@interface WAAPIProxy ()
@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@end

@implementation WAAPIProxy

#pragma mark - life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static WAAPIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WAAPIProxy new];
    });
    return sharedInstance;
}

#pragma mark - public method

- (NSUInteger)callPOSTWithUrlString:(NSString *)urlString
                            params:(NSDictionary *)params
                           success:(WAAPICallBack)success
                              fail:(WAAPICallBack)fail
{
    NSURLSessionDataTask *task = [self.httpSessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WAURLResponse *response = [[WAURLResponse alloc] initWithHttpMethod:@"POST" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:responseObject status:WAURLResponseStatusSuccess error:nil];
        success?success(response):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WAURLResponse *response = nil;
        if (error.code == NSURLErrorTimedOut)
        {
            response = [[WAURLResponse alloc] initWithHttpMethod:@"POST" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:nil status:WAURLResponseStatusErrorTimeout error:error];
        }
        else
        {
            response = [[WAURLResponse alloc] initWithHttpMethod:@"POST" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:nil status:WAURLResponseStatusErrorNoNetwork error:error];
        }
        fail?fail(response):nil;

    }];
    return task.taskIdentifier;
}

- (NSUInteger)callGETWithUrlString:(NSString *)urlString
                           params:(NSDictionary *)params
                          success:(WAAPICallBack)success
                             fail:(WAAPICallBack)fail
{
    NSURLSessionDataTask *task = [self.httpSessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WAURLResponse *response = [[WAURLResponse alloc] initWithHttpMethod:@"GET" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:responseObject status:WAURLResponseStatusSuccess error:nil];
        success?success(response):nil;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WAURLResponse *response = nil;
        if (error.code == NSURLErrorTimedOut)
        {
             response = [[WAURLResponse alloc] initWithHttpMethod:@"GET" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:nil status:WAURLResponseStatusErrorTimeout error:error];
        }
        else
        {
            response = [[WAURLResponse alloc] initWithHttpMethod:@"GET" requestID:task.taskIdentifier request:task.originalRequest response:task.response responseData:nil status:WAURLResponseStatusErrorNoNetwork error:error];
        }
        fail?fail(response):nil;
        
    }];
    return task.taskIdentifier;
}

- (void)cancelRequestWithRequestID:(NSUInteger)requestID
{
    [self.httpSessionManager.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionTask *task in tasks)
        {
            if (task.taskIdentifier == requestID)
            {
                [task cancel];
            }
        }
    }];
}

- (void)cancelAllRequestImmediately
{
    [self.httpSessionManager.session invalidateAndCancel];
}

- (void)cancelAllRequestAfterCurrentRequestsFinished
{
    [self.httpSessionManager.session finishTasksAndInvalidate];
}

- (BOOL)networkIsReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - setter and getter

- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager)
    {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WAAPIBaseURLString] sessionConfiguration:nil];
        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_httpSessionManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _httpSessionManager.requestSerializer.timeoutInterval = kWANetworkingTimeoutSeconds;
    }
    return _httpSessionManager;
}

@end
