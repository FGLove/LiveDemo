//
//  FGMainViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGMainViewController.h"
#import "FGAnchorListViewController.h"
#import "FGLiveCollectViewController.h"

@interface FGMainViewController ()

@end

@implementation FGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击了主播列表按钮
- (IBAction)anchorListBtnClick:(UIButton *)sender {
    
    FGAnchorListViewController *anchorVc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    
    [self.navigationController showViewController:anchorVc sender:nil];
}

// 直播采集
- (IBAction)liveColletBtnClick:(UIButton *)sender {
    
    FGLiveCollectViewController *collectVc = [[UIStoryboard storyboardWithName:@"Collect" bundle:nil] instantiateInitialViewController];
    
    [self.navigationController showViewController:collectVc sender:nil];
}





@end
