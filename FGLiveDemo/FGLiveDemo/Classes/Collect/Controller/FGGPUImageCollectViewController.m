//
//  FGGPUImageCollectViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/12.
//  Copyright © 2016年 chfg. All rights reserved.
//

#import "FGGPUImageCollectViewController.h"
#import <GPUImage/GPUImage.h>

@interface FGGPUImageCollectViewController ()

/** GPUImage视频源 */
@property(nonatomic,strong)GPUImageVideoCamera *gpuVideoCamera;

/** 磨皮滤镜 */
@property(nonatomic,strong)GPUImageBilateralFilter *bilateralFilter;
/** 美白滤镜 */
@property(nonatomic,strong)GPUImageBrightnessFilter *brightnessFilter;

@end

@implementation FGGPUImageCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGPUImageCaputureVideo];

}

/// GPU采集视频 (原生美颜)
- (void)setupGPUImageCaputureVideo
{
    // 1.创建视频源
    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    GPUImageVideoCamera *gpuVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    gpuVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.gpuVideoCamera = gpuVideoCamera;
    
    // 2.创建最终预览的view
    GPUImageView *captureVuewPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVuewPreview atIndex:0];
    
    // 3.创建滤镜： 磨皮、美白组合滤镜
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    
    // 磨皮滤镜
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [filterGroup addTarget:bilateralFilter];
    self.bilateralFilter = bilateralFilter;
    
    // 美白滤镜
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [filterGroup addTarget:brightnessFilter];
    self.brightnessFilter = brightnessFilter;
    
    // 设置滤镜组链
    [bilateralFilter addTarget:brightnessFilter];
    [filterGroup setInitialFilters:@[bilateralFilter]];
    filterGroup.terminalFilter = brightnessFilter;
    
    // 设置GPUImage处理链 从数据源 => 滤镜 => 最终界面效果
    [gpuVideoCamera addTarget:filterGroup];
    [filterGroup addTarget:captureVuewPreview];
    
    /// 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    // 开始采集视频
    [gpuVideoCamera startCameraCapture];
}

/// 磨皮效果
- (IBAction)bilateralFilterValueChanged:(UISlider *)sender {
    // 值越小，磨皮效果越好
    CGFloat maxValue = 10;
    [self.bilateralFilter setDistanceNormalizationFactor:(maxValue - sender.value)];
}
/// 美白效果
- (IBAction)brightnessFilterValueChanged:(UISlider *)sender {
    self.brightnessFilter.brightness = sender.value;
}

@end
