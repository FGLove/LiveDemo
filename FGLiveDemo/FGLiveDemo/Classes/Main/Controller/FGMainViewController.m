//
//  FGMainViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/10.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGMainViewController.h"
#import "FGAnchorListViewController.h"

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



@end
