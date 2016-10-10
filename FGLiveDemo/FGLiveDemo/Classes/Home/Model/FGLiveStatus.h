//
//  FGLiveStatus.h
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//  一条直播

#import <Foundation/Foundation.h>

@class FGCreator;

@interface FGLiveStatus : NSObject

/** id */
@property(nonatomic,copy)NSString *ID;

/** 在线人数 */
@property(nonatomic,assign)int online_users;

/** share_addr */
@property(nonatomic,copy)NSString *share_addr;

/** 主播 */
@property(nonatomic,strong)FGCreator *creator;

/** 城市 */
@property(nonatomic,copy)NSString *city;

/** 拉流地址 */
@property(nonatomic,copy)NSString *stream_addr;



@end
