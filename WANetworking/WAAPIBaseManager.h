//
//  WAAPIBaseManager.h
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAAPIBaseManager;

/*************************************************************************************************/
/*                             WAAPIManagerParamSourceDelegate                                   */
/*************************************************************************************************/
/**
 *  请求参数收集逻辑 所有的请求参数都在此收集
 */
@protocol WAAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForAPIManager:(WAAPIBaseManager *)manager;
@end

/*************************************************************************************************/
/*                                  WAAPIManagerValidator                                        */
/*************************************************************************************************/
/**
 *  在发送请求前对入参检查 在请求返回后对回参检查
    这里由于在ViewController里面可能包含多个APIManager,这些APIManager的Validator都由这个ViewController实现,
    所以将当前的APIManager作为参数传进来以作区分
    在ViewController中实现此协议时,使用[apiManager isKindOfClass:[XXXAPIManager class]]的方式来区分
 */
@protocol WAAPIManagerValidator <NSObject>
@optional
- (BOOL)manager:(__kindof WAAPIBaseManager *)manager isCorrectWithParams:(NSDictionary *)params;
- (BOOL)manager:(__kindof WAAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)callBackData;
@end

/*************************************************************************************************/
/*                             WAAPIManagerAPICallBackDelegate                                   */
/*************************************************************************************************/
/**
 *  请求回调
    这里由于在ViewController里面可能包含多个APIManager,这些APIManager的callBackDelegate都由这个ViewController实现,
    所以将当前的APIManager作为参数传进来以作区分
    在ViewController中实现此协议时,使用[apiManager isKindOfClass:[XXXAPIManager class]]的方式来区分
 */
@protocol WAAPIManagerAPICallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccessWithAPIManager:(__kindof WAAPIBaseManager *)apiManager
                                  responseData:(NSDictionary *)responseData;
- (void)managerCallAPIDidFailedWithAPIManager:(__kindof WAAPIBaseManager *)apiManager
                                    ErrorType:(WAAPIManagerErrorType)errorType;
@end

/*************************************************************************************************/
/*                                       WAAPIManager                                            */
/*************************************************************************************************/
/**
 *  提供请求的URL及请求类型:POST/GET 
 *
 *  ***所有继承的类必须实现此协议***
 */
@protocol WAAPIManager <NSObject>
@required
- (NSString *)serviceUrlString;
- (WAAPIManagerRequestType)requestType;
@end

/*************************************************************************************************/
/*                                     WAAPIBaseManager                                          */
/*************************************************************************************************/
/**
 *  每一个网络接口对应一个类 并且必须继承自WAAPIBaseManager
 */
@interface WAAPIBaseManager : NSObject
/**
 *  若需要参数且参数为可变逻辑,则paramSource为ViewController
 *  若需要参数且参数为固定逻辑,则paramSource为继承的APIManager自身
 *  若不需要参数,则paramSource可为空
 */
@property (nonatomic, weak) id <WAAPIManagerParamSourceDelegate> paramSource;
/**
 *  通常validator为继承的APIManager,因为每个API的入参和出参的正确标准不同,需要API自己去判断
 */
@property (nonatomic, weak) id <WAAPIManagerValidator> validator;
/**
 *  通常为callBackDelegate为ViewController
 */
@property (nonatomic, weak) id <WAAPIManagerAPICallBackDelegate> callBackDelegate;
/**
 *  通常child为继承的APIManager自身,在初始化init里面设置,
 *  且必须实现WAAPIManager协议,否则程序会Crash,使用这种方式来强制业务方
 */
@property (nonatomic, weak) NSObject <WAAPIManager> *child;
/**
 *  [发起请求]
 
    所有继承的APIManager发起请求时都是用这个方法
 */
- (void)loadData;
/**
 *  [结束当前APIManager的请求]
 
    所有继承的APIManager关闭请求时都是用这个方法
 */
- (void)cancelRequest;
/**
 *  [结束所有请求]
 
    不仅当前APIManager的请求回结束,APP内所有正在请求的API都会结束,因为WANetworking使用的是单例的AFHTTPSessionManager
 */
- (void)cancelAllRequest;
/**
 *  [结束所有请求]
 
    与上面的cancelAllRequest区别是：cancelAllRequest会立即结束所有请求,而这个会等待当前所有请求结束后再关闭所有请求
 */
- (void)cancelAllRequestAfterCurrentRequestsFinished;

@end
