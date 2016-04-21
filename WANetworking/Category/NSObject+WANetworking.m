//
//  NSObject+WANetworking.m
//  WANetworking
//
//  Created by 赵鸣镝 on 16/1/6.
//  Copyright © 2016年 赵鸣镝. All rights reserved.
//

#import "NSObject+WANetworking.h"

@implementation NSObject (WANetworking)

- (id)WA_DefaultValue:(id)defaultValue
{
    if (![defaultValue isKindOfClass:[self class]])
    {
        return self;
    }
    
    if ([self WA_IsEmptyObject])
    {
        return defaultValue;
    }
    
    return self;
}

- (BOOL)WA_IsEmptyObject
{
    if ([self isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]])
    {
        if ([(NSString *)self length] == 0)
        {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]])
    {
        if ([(NSArray *)self count] == 0)
        {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]])
    {
        if ([(NSDictionary *)self count] == 0)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
