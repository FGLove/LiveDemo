//
//  FGLiveStatusCell.h
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGLiveStatus;

@interface FGLiveStatusCell : UITableViewCell

/** 模型 */
@property(nonatomic,strong)FGLiveStatus *liveStatus;

@end
