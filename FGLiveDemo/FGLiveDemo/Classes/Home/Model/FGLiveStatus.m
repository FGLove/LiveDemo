//
//  FGLiveStatus.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGLiveStatus.h"
#import <MJExtension/MJExtension.h>

@implementation FGLiveStatus

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end
