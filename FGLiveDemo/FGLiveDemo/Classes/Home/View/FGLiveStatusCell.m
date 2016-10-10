//
//  FGLiveStatusCell.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGLiveStatusCell.h"
#import "FGLiveStatus.h"
#import "FGCreator.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FGLiveStatusCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
/** 在线人数 */
@property (weak, nonatomic) IBOutlet UILabel *onlinePeopleLabel;
/** 城市 */
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
/** 缩略图 */
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@end

@implementation FGLiveStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setLiveStatus:(FGLiveStatus *)liveStatus
{
    _liveStatus = liveStatus;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",liveStatus.creator.portrait]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.namelabel.text = liveStatus.creator.nick;
    
    self.onlinePeopleLabel.text = [NSString stringWithFormat:@"%d",liveStatus.online_users];
    
    if (liveStatus.city.length > 0) {
        self.cityLabel.text = liveStatus.city;
    }else{
        self.cityLabel.text = @"大概是住在火星上吧";
    }
    
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",liveStatus.creator.portrait]] placeholderImage:nil];
}


@end
