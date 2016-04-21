//
//  WAURLResponse.h
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/5.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAURLResponse : NSObject

@property (nonatomic, readonly, assign) WAURLResponseStatus status;
@property (nonatomic, readonly, copy) NSString *httpMethod;
@property (nonatomic, readonly, assign) NSInteger requestID;
@property (nonatomic, readonly, copy) NSURLRequest *request;
@property (nonatomic, readonly, copy) NSURLResponse *response;
@property (nonatomic, readonly, copy) id responseData;
@property (nonatomic, readonly, copy) NSError *error;

- (instancetype)initWithHttpMethod:(NSString *)httpMethod
                         requestID:(NSInteger)requestID
                           request:(NSURLRequest *)request
                          response:(NSURLResponse *)response
                      responseData:(id)responseData
                            status:(WAURLResponseStatus)status
                             error:(NSError *)error;

@end
