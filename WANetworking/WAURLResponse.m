//
//  WAURLResponse.m
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import "WAURLResponse.h"

@interface WAURLResponse ()
@property (nonatomic, readwrite, assign) WAURLResponseStatus status;
@property (nonatomic, readwrite, copy) NSString *httpMethod;
@property (nonatomic, readwrite, assign) NSInteger requestID;
@property (nonatomic, readwrite, copy) NSURLRequest *request;
@property (nonatomic, readwrite, copy) NSURLResponse *response;
@property (nonatomic, readwrite, copy) id responseData;
@property (nonatomic, readwrite, copy) NSError *error;
@end

@implementation WAURLResponse

- (instancetype)initWithHttpMethod:(NSString *)httpMethod
                         requestID:(NSInteger)requestID
                           request:(NSURLRequest *)request
                          response:(NSURLResponse *)response
                      responseData:(id)responseData
                            status:(WAURLResponseStatus)status
                             error:(NSError *)error;
{
    self = [super init];
    if (!self) return nil;
    
    _httpMethod = httpMethod;
    _requestID = requestID;
    _request = request;
    _response = response;
    _responseData = responseData;
    _status = status;
    _error = error;

    return self;
}

@end
