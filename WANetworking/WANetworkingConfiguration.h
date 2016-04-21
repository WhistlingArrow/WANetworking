
//
//  WANetworkingConfiguration.h
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#ifndef WANetworkingConfiguration_h
#define WANetworkingConfiguration_h

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, WAAPIManagerRequestType){
    WAAPIManagerRequestTypeGet,
    WAAPIManagerRequestTypePost
};

typedef NS_ENUM(NSUInteger, WAURLResponseStatus)
{
    WAURLResponseStatusSuccess,
    WAURLResponseStatusErrorTimeout,
    WAURLResponseStatusErrorNoNetwork        // 默认除了超时以外的错误都是无网络错误
};

typedef NS_ENUM (NSUInteger, WAAPIManagerErrorType){
    WAAPIManagerErrorTypeDefault,            //没有产生过API请求 manager的默认状态
    WAAPIManagerErrorTypeParamsError,        //参数错误 此时manager不会调用API,因为参数验证是在调用API之前
    WAAPIManagerErrorTypeResponseDataError,  //API请求成功但返回数据不正确
    WAAPIManagerErrorTypeTimeout,            //请求超时
    WAAPIManagerErrorTypeNoNetWork           //网络不通 在调用API之前会判断一下当前网络是否通畅,这个也是在调用API之前验证的
};

static NSTimeInterval kWANetworkingTimeoutSeconds = 20.0f; //请求超时设置（单位：秒）
static NSString * const WAAPIBaseURLString = @"http://124.207.60.82:8070/ebb-api/";//这里替换成你的BaseURL

#endif /* WANetworkingConfiguration_h */
