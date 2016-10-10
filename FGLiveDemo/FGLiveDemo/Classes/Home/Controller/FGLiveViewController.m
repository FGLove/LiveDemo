//
//  FGLiveViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGLiveViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FGLiveStatus.h"
#import "FGCreator.h"
#import <IJKMediaFramework/IJKMediaFramework.h>


@interface FGLiveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;

/** 强引用直播控制器 */
@property(nonatomic,strong)IJKFFMoviePlayerController *mpVc;
@end

@implementation FGLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//     设置直播占位图片
    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",self.liveStatus.creator.portrait]] placeholderImage:nil];
    
    // 拉流地址
    NSURL *url = [NSURL URLWithString:self.liveStatus.stream_addr];
    
    
    
    // 创建IJKFFMoviePlayerController（用来专门做直播的类）该控制器要 强引用
    IJKFFMoviePlayerController *mpVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];

    self.mpVc = mpVc;
    
    // 准备播放
    [mpVc prepareToPlay];
    
    mpVc.view.frame = [UIScreen mainScreen].bounds;
    
    // 添加到 当前控制器的view中
    [self.view insertSubview:mpVc.view atIndex:1];
    
}

// 界面消失，停止播放
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mpVc pause];
    [_mpVc stop];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLiveStatus:(FGLiveStatus *)liveStatus
{
    _liveStatus = liveStatus;
}

@end
