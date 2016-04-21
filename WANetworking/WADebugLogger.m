
//
//  WADebugLogger.m
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/6.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import "WADebugLogger.h"
#import "NSObject+WANetworking.h"

@implementation WADebugLogger

+ (void)logDebugInfoWithResponse:(WAURLResponse *)response
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    if (response.error) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", response.error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)response.error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", response.error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", response.error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", response.error.localizedRecoverySuggestion];
    }
    [logString appendFormat:@"Content:\n%@\n\n", [response.responseData WA_DefaultValue:@"N/A"]];
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendFormat:@"\n\nHTTP Method:\t\t\t%@", [response.httpMethod WA_DefaultValue:@"N/A"]];
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", response.request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", response.request.allHTTPHeaderFields ? response.request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n%@", (NSDictionary *)[NSJSONSerialization JSONObjectWithData:response.request.HTTPBody options:NSJSONReadingMutableContainers error:NULL]];
    [logString appendFormat:@"\n\nHTTP Body(提供给后台人员的JSON格式):\n\t%@", [[[NSString alloc] initWithData:response.request.HTTPBody encoding:NSUTF8StringEncoding] WA_DefaultValue:@"\t\t\t\tN/A"]];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    NSLog(@"%@", logString);
    
}

@end
