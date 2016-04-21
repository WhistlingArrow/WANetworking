//
//  WADebugLogger.h
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/6.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAURLResponse.h"

@interface WADebugLogger : NSObject

+ (void)logDebugInfoWithResponse:(WAURLResponse *)response;

@end
