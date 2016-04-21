
//
//  WAAPIBaseManager.m
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import "WAAPIBaseManager.h"
#import "WAAPIProxy.h"
#import "WADebugLogger.h"

@interface WAAPIBaseManager ()
@property (nonatomic, assign) NSUInteger currentRequestID;
@end

@implementation WAAPIBaseManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _currentRequestID = 0;
    _paramSource = nil;
    _validator = nil;
    _callBackDelegate = nil;
    
    if ([self conformsToProtocol:@protocol(WAAPIManager)])
    {
        _child = (id <WAAPIManager>)self;
    }
    else
    {
        //强制自类实现APIManager协议，若未实现直接让程序Crash
        NSAssert(NO, @"WAAPIBaseManager的子类必须要实现APIManager协议");
    }
    
    return self;
}

- (void)dealloc
{
    [self cancelRequest];
}

#pragma mark - public method

- (void)loadData
{
    NSInteger requestID = 0;
    if (self.paramSource && [self.paramSource respondsToSelector:@selector(paramsForAPIManager:)])
    {
        NSDictionary *params = [self.paramSource paramsForAPIManager:self];
        requestID = [self loadDataWithParams:params];
    }
    else
    {
        requestID = [self loadDataWithParams:nil];
    }
    self.currentRequestID = requestID;
}

- (void)cancelRequest
{
    if (self.currentRequestID != 0)
    {
        [[WAAPIProxy sharedInstance] cancelRequestWithRequestID:self.currentRequestID];
        self.currentRequestID = 0;
    }
}

- (void)cancelAllRequest
{
    [[WAAPIProxy sharedInstance] cancelAllRequestImmediately];
}

- (void)cancelAllRequestAfterCurrentRequestsFinished
{
    [[WAAPIProxy sharedInstance] cancelAllRequestAfterCurrentRequestsFinished];
}

#pragma mark - api call

- (NSUInteger)loadDataWithParams:(NSDictionary *)params
{
    NSUInteger requestID = 0;
    if ([self shouldCallAPIWithParams:params])
    {
        switch (self.child.requestType)
        {
            case WAAPIManagerRequestTypePost:
            {
                requestID = [[WAAPIProxy sharedInstance] callPOSTWithUrlString:self.child.serviceUrlString params:params success:^(WAURLResponse *response) {
                    [WADebugLogger logDebugInfoWithResponse:response];
                    [self successedOnCallingAPI:response];
                } fail:^(WAURLResponse *response) {
                    [WADebugLogger logDebugInfoWithResponse:response];
                    [self failedOnCallingAPI:response withErrorType:WAAPIManagerErrorTypeDefault];
                }];
                break;
            }
            case WAAPIManagerRequestTypeGet:
            {
                requestID = [[WAAPIProxy sharedInstance] callGETWithUrlString:self.child.serviceUrlString params:params success:^(WAURLResponse *response) {
                    [WADebugLogger logDebugInfoWithResponse:response];
                    [self successedOnCallingAPI:response];
                } fail:^(WAURLResponse *response) {
                    [WADebugLogger logDebugInfoWithResponse:response];
                    [self failedOnCallingAPI:response withErrorType:WAAPIManagerErrorTypeDefault];
                }];
                break;
            }
            default:
                break;
        }

    }
    else
    {
        requestID = 0;
    }
    return requestID;
}

#pragma mark - api callback

- (void)successedOnCallingAPI:(WAURLResponse *)response
{
    if (self.validator && [self.validator respondsToSelector:@selector(manager:isCorrectWithCallBackData:)])
    {
        if ([self.validator manager:self isCorrectWithCallBackData:response.responseData])
        {
            [self.callBackDelegate managerCallAPIDidSuccessWithAPIManager:self responseData:response.responseData];
        }
        else
        {
            [self failedOnCallingAPI:response withErrorType:WAAPIManagerErrorTypeResponseDataError];
        }
    }
    else
    {
        [self.callBackDelegate managerCallAPIDidSuccessWithAPIManager:self responseData:response.responseData];
    }
}

- (void)failedOnCallingAPI:(WAURLResponse *)response withErrorType:(WAAPIManagerErrorType)errorType
{
    if (response.status == WAURLResponseStatusErrorTimeout)
    {
        [self.callBackDelegate managerCallAPIDidFailedWithAPIManager:self ErrorType:WAAPIManagerErrorTypeTimeout];
    }
    else
    {
        [self.callBackDelegate managerCallAPIDidFailedWithAPIManager:self ErrorType:errorType];
    }
}

#pragma mark - api call detection

//发起请求前的最后检测 目前只检测网络状态、请求参数。待加：缓存策略等
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (![WAAPIProxy sharedInstance].networkIsReachable)
    {
        [self failedOnCallingAPI:nil withErrorType:WAAPIManagerErrorTypeNoNetWork];
        return NO;
    }
    if (self.validator && [self.validator respondsToSelector:@selector(manager:isCorrectWithParams:)])
    {
        if (![self.validator manager:self isCorrectWithParams:params])
        {
            [self failedOnCallingAPI:nil withErrorType:WAAPIManagerErrorTypeParamsError];
            return NO;
        }
    }
    return YES;
}

@end
