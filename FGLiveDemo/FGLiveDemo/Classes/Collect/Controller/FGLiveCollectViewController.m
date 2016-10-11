//
//  FGLiveCollectViewController.m
//  FGLiveDemo
//
//  Created by chfg on 16/10/11.
//  Copyright © 2016年 chfg. All rights reserved.
//

/*
 1.创建AVCaptureSession对象
 2.获取AVCaptureDevicel录像设备（摄像头），录音设备（麦克风），注意不具备输入数据功能,只是用来调节硬件设备的配置。
 3.根据音频/视频硬件设备(AVCaptureDevice)创建音频/视频硬件输入数据对象(AVCaptureDeviceInput)，专门管理数据输入。
 4.创建视频输出数据管理对象（AVCaptureVideoDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的视频数据
 5.创建音频输出数据管理对象（AVCaptureAudioDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的音频数据
 6.将数据输入对象AVCaptureDeviceInput、数据输出对象AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中,就会自动让音频输入与输出和视频输入与输出产生连接.
 7.创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器layer中
 8.启动AVCaptureSession，只有开启，才会开始输入到输出数据流传输。
 
 文／袁峥Seemygo（简书作者）
 原文链接：http://www.jianshu.com/p/c71bfda055fa
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */

#import "FGLiveCollectViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface FGLiveCollectViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

/** 会话（协调输入与输出之间传输数据） */
@property(nonatomic,strong)AVCaptureSession *captureSession;

/** 视频输入数据对象 */
@property(nonatomic,strong)AVCaptureDeviceInput *videoDeviceInput;

/** 视频输入与输出连接 */
@property(nonatomic,strong)AVCaptureConnection *videoConnection;

/** 视频预览图层 */
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previedLayer;

@property (nonatomic, weak) UIImageView *focusCursorImageView;


@end

@implementation FGLiveCollectViewController

/**
 *  懒加载聚焦视图
 *
 */
- (UIImageView *)focusCursorImageView
{
    if (_focusCursorImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
        _focusCursorImageView = imageView;
        [self.view addSubview:_focusCursorImageView];
    }
    return _focusCursorImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCaputureVideo];
}

// 捕获音视频
- (void)setupCaputureVideo{
    
    // 1.创建捕获会话 （要强引用）
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    self.captureSession = captureSession;

    // 2.1获取摄像头设备 （AVCaptureDevicePositionBack 后置摄像头 AVCaptureDevicePositionFront 前置摄像头）
    AVCaptureDevice *videoDevice = [self getVideoDevice:(AVCaptureDevicePositionBack)];
    
    // 2.2获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    // 3.1创建视频输入数据对象 （要强引用,记录，便于后面更改摄像头时 需要 该对象）
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    self.videoDeviceInput = videoDeviceInput;
    
    // 3.2创建音频输入数据对象
    NSError *error;
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    NSLog(@"%@",error);
    
    // 4.添加到会话中 (最好要判断)
    if ([captureSession canAddInput:videoDeviceInput]) {
        [captureSession addInput:videoDeviceInput];
    }
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    // 5.获取视频输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 5.1 设置代理，捕获视频样品数据
    // 注意，队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    // 5.2 添加到会话中
    if ([captureSession canAddOutput:videoOutput]) {
        [captureSession addOutput:videoOutput];
    }
    
    // 6.获取音频输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([captureSession canAddOutput:audioOutput]) {
        [captureSession addOutput:audioOutput];
    }
    
    // 7.获取视频输入与输出连接，用于分辨音视频数据 （要强引用）
    AVCaptureConnection *videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    self.videoConnection = videoConnection;

    // 8.添加到视频预览图层 (要强引用)
    AVCaptureVideoPreviewLayer *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previedLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previedLayer atIndex:0];
    _previedLayer = previedLayer;
    
    // 9启动会话
    [captureSession startRunning];
    
}

// 获取指定的摄像头设备(前置摄像头 or 后置 摄像头)
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取输入设备数据，有可能是音频有可能是视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.videoConnection == connection) {
        NSLog(@"采集到视频数据");
    } else {
        NSLog(@"采集到音频数据");
    }
}

// 切换摄像头
- (IBAction)toggleCapture:(UIButton *)sender {
    
    // 获取当前设备（镜头）方向
    AVCaptureDevicePosition curPosition = self.videoDeviceInput.device.position;
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = (curPosition == AVCaptureDevicePositionFront? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront);
    
    // 获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    // 移除之前的摄像头输入设备
    [self.captureSession removeInput:self.videoDeviceInput];
    
    // 添加新的摄像头输入设备
    [self.captureSession addInput:toggleDeviceInput];
    
    // 记录当前的摄像头输入设备
    self.videoDeviceInput = toggleDeviceInput;
}

// 聚焦光标
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取点击位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // 把当前位置转换为摄像头点的位置
    CGPoint cameraPoint = [self.previedLayer captureDevicePointOfInterestForPoint:point];
    
    // 设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    // 设置聚焦(AVCaptureFocusModeContinuousAutoFocus: 自动聚焦模式 AVCaptureExposureModeAutoExpose: 自动曝光模式)
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
    
}

/// 设置聚焦点位置
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha = 0.0;
    }];
    
}

/**
    设置聚焦
    AVCaptureFocusMode: 聚焦模式
    AVCaptureExposureMode: 曝光模式
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    // 取出视频设备
    AVCaptureDevice *captureDevice = self.videoDeviceInput.device;
    
    // 锁定🔐配置
    [captureDevice lockForConfiguration:nil];
    
    // 设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    
    // 设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    
    // 解锁🔓配置
    [captureDevice unlockForConfiguration];
}

@end
