//
//  FGBeautifyCameraCollectViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/12.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGBeautifyCameraCollectViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface FGBeautifyCameraCollectViewController ()

/** GPUImage视频源 */
@property(nonatomic,strong)GPUImageVideoCamera *gpuVideoCamera;

/** 最终预览的view */
@property(nonatomic,strong)GPUImageView *captureViewPreview;

@end

@implementation FGBeautifyCameraCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 1.创建视频源
    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    GPUImageVideoCamera *gpuVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    gpuVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.gpuVideoCamera = gpuVideoCamera;
    
    // 2.创建最终预览的view
    GPUImageView *captureViewPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureViewPreview atIndex:0];
    self.captureViewPreview = captureViewPreview;
    
    // 设置处理链
    [_gpuVideoCamera addTarget:captureViewPreview];
    
    // 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    // 开始采集视频
    [gpuVideoCamera startCameraCapture];
}
- (IBAction)beautilyTypeValueChanged:(UISwitch *)sender {
    
    // 切换美颜效果原理：移除之前所有处理链，重新设置处理链
    if (sender.on) {
        
        // 移除之前所有处理链
        [self.gpuVideoCamera removeAllTargets];
        
        // 创建美颜滤镜
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        
        // 设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
        [self.gpuVideoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.captureViewPreview];
        
    } else {
        
        // 移除之前所有处理链
        [self.gpuVideoCamera removeAllTargets];
        [self.gpuVideoCamera addTarget:self.captureViewPreview];
    }
}

@end
