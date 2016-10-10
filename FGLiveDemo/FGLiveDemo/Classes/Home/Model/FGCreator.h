//
//  FGCreator.h
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//  主播

#import <Foundation/Foundation.h>

@interface FGCreator : NSObject
/** 性别 */
@property(nonatomic,assign) int gender;

/** ID */
@property(nonatomic,assign) double ID;

/** 等级 */
@property(nonatomic,assign) int level;

/** 昵称 */
@property(nonatomic,copy) NSString *nick;

/** 头像 */
@property(nonatomic,copy) NSString *portrait;

@end
