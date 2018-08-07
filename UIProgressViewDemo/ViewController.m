//
//  ViewController.m
//  UIProgressViewDemo
//
//  Created by knight on 2018/8/4.
//  Copyright © 2018年 knight. All rights reserved.
//

#define KSCREEN_W [UIScreen mainScreen].bounds.size.width
#define KSCREEN_H [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "CustomProgressView.h"
#import "CustomSlider.h"

@interface ViewController ()

/** 进度条 */
@property (nonatomic,strong) CustomProgressView *progressView;
/** slideView */
@property (nonatomic,strong) CustomSlider *slideView;
/** 进度 */
@property (nonatomic, strong) NSProgress *progress;
/** 进度百分比 */
@property (nonatomic,strong) UILabel *labPro;

@property (nonatomic,strong) UILabel *labMin;
@property (nonatomic,strong) UILabel *labMax;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 完成所需要的..
    self.progress = [NSProgress progressWithTotalUnitCount:100];
    
    // 通过传值或者从服务器获取 , 设置值
    self.progress.completedUnitCount = 66;
    
    [self setupLoad];
    [self setupDefault];
}

/** 懒加载 */
- (void) setupLoad
{
    [self slideView];
    [self progressView];
    [self labPro];
    [self labMin];
    [self labMax];
}

/** 初始值 */
- (void)setupDefault
{
    // 滑动条的默认值
    self.slideView.value  = self.progress.completedUnitCount / 100.0f;
    
    // 是否符合规范
    long long int com = self.progress.completedUnitCount > 100 ? 100 :  self.progress.completedUnitCount;
    // 比例
    CGFloat x = (1.0 * com / self.progress.totalUnitCount) *(KSCREEN_W- 40);
    // 是否大于进度条的宽度
    CGFloat isW  = (x == self.progressView.frame.size.width) ? 50 : 20;
    
    // 当前指示值的位置
    CGRect lbRect = self.labPro.frame ;
    lbRect.origin.x = (x <20) ? (x + 20) : x - isW;
    lbRect.origin.y = CGRectGetMaxY(self.progressView.frame) + 15;
    self.labPro.frame = lbRect;
    
    //当前指示值的
    self.labPro.text = [NSString stringWithFormat:@"%.2f%%",(1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount)*100];
    // 进度条的当前值
    CGFloat progressF = 1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount;
    [self.progressView setProgress:progressF animated:YES];
}


-(UILabel *)labPro
{
    if (!_labPro) {
        _labPro = [[UILabel alloc]init];
        _labPro.textColor = [UIColor whiteColor];
        _labPro.backgroundColor = [UIColor redColor];
        _labPro.font = [UIFont systemFontOfSize:14];
        _labPro.frame = CGRectMake((KSCREEN_W - 80)/2, 70, 80, 30);
        _labPro.textAlignment = NSTextAlignmentCenter;
        _labPro.text = @"0.0%";
        _labPro.layer.masksToBounds  = YES;
        _labPro.layer.cornerRadius = 5;
//        [_labPro sizeToFit];
        [self.view addSubview:_labPro];
    }
    return _labPro;
}
-(UILabel *)labMin
{
    if (!_labMin) {
        _labMin = [[UILabel alloc]init];
        _labMin.textColor = [UIColor darkGrayColor];
        _labMin.font = [UIFont systemFontOfSize:14];
        _labMin.frame = CGRectMake(CGRectGetMinX(self.progressView.frame), CGRectGetMaxY(self.progressView.frame) + 10, 80, 30);
        _labMin.textAlignment = NSTextAlignmentCenter;
        _labMin.text = @"0";
        [_labMin sizeToFit];
        [self.view addSubview:_labMin];
    }
    return _labMin;
}
-(UILabel *)labMax
{
    if (!_labMax) {
        _labMax = [[UILabel alloc]init];
        _labMax.textColor = [UIColor darkGrayColor];
        _labMax.font = [UIFont systemFontOfSize:14];
        _labMax.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame) - 20, CGRectGetMaxY(self.progressView.frame) + 10, 80, 30);
        _labMax.textAlignment = NSTextAlignmentCenter;
        _labMax.text = [NSString stringWithFormat:@"%lld",self.progress.totalUnitCount];
        [_labMax sizeToFit];
        [self.view addSubview:_labMax];
    }
    return _labMax;
}

#pragma mark - 懒加载 进度条

- (CustomSlider *)slideView
{
    if (!_slideView) {
        _slideView = [[CustomSlider alloc]initWithFrame:CGRectMake(0, 400.0, (CGRectGetWidth(self.view.bounds) ), 5.0)];
        _slideView.value = 0.5;
        //[_slideView setValue:0.5 animated:YES];
        // 当前的指示球的背景色
        _slideView.thumbTintColor = [UIColor cyanColor];
        // 最大值. 最小值
        //_slideView.minimumValue = 0.3;
        //_slideView.maximumValue = 0.8;
        
        //_slideView.minimumTrackTintColor = [UIColor redColor];
        //_slideView.maximumTrackTintColor = [UIColor greenColor];
        _slideView.minimumValueImage = [UIImage imageNamed:@"蜗牛.png"];
        _slideView.maximumValueImage = [UIImage imageNamed:@"高铁.png"];
        
       
        // 添加响应方法
        [_slideView addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
        // 添加到父视图
        [self.view addSubview:_slideView];
    }
    return _slideView;
}

- (CustomProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[CustomProgressView alloc]initWithFrame:CGRectMake(20, 150, KSCREEN_W - 40 , 90)];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.progressTintColor = [UIColor purpleColor];
        _progressView.trackTintColor = [UIColor orangeColor];
        _progressView.tag = 1000;
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = 2;
        // 有动画
        //[_progressView setProgress:0.5 animated:YES];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

// 实现滑动响应方法
- (void)slideAction:(UISlider *)slider
{
    float sliderValue = slider.value;
    NSLog(@"sliderValue = %f", sliderValue);
    
    UIProgressView *progressview = (UIProgressView *)[self.view viewWithTag:1000];
    progressview.progress = sliderValue;
    

    self.labPro.text = [NSString stringWithFormat:@"%.2f%%",(100.0 * self.progressView.progress / self.progress.totalUnitCount)*100];
    
    
    CGFloat com = (100.0 * self.progressView.progress / self.progress.totalUnitCount);
    
    NSLog(@"==%f", com);
    // 比例
    CGFloat x = (100.0 * self.progressView.progress / self.progress.totalUnitCount) *(KSCREEN_W- 40);
    // 是否大于进度条的宽度
    CGFloat isW  = (x == self.progressView.frame.size.width) ? 50 : 20;
    
    // 当前指示值的位置
    CGRect lbRect = self.labPro.frame ;
    lbRect.origin.x = (x <20) ? (x + 20) : x - isW;
    lbRect.origin.y = CGRectGetMaxY(self.progressView.frame) + 15;
    self.labPro.frame = lbRect;
    
    // 重新开始
//    [self.timer fire];
}


/** KVO回调方法  */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //获取观察的新值
    CGFloat value = [change[NSKeyValueChangeNewKey] doubleValue];
    //打印
    NSLog(@"fractionCompleted --- %f, localizedDescription --- %@, localizedAdditionalDescription --- %@-- %.2f", value, self.progress.localizedDescription, self.progress.localizedAdditionalDescription,(1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount)*100);
    
//    NSLog(@"已经完成进度%.2f === 总进度%.2f === %.2f",1.0 *self.progress.completedUnitCount ,self.progress.totalUnitCount *1.0,(1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount));
    //0.4 / 10 = x / 375
    //当前zhi / 100 = x / 375
    //((value *100) / (1.0*self.progress.totalUnitCount)) *(KSCREEN_W-40);
    
    
#if 0
    // 判断是否符合规范
    long long int com = value > 100 ? 100 :  self.progress.completedUnitCount;
    // 比例
    CGFloat x1 = (1.0 * com / self.progress.totalUnitCount) *(KSCREEN_W- 40);
    // 是否大于进度条的宽度
    CGFloat isW  = (x1 == self.progressView.frame.size.width) ? 50 : 20;
    
    // 1.通过整体位置设置指示器 的位置
    CGRect lbRect = self.labPro.frame ;
    lbRect.origin.x = (x1 <20) ? (x1 + 20) : x1 - isW;
    lbRect.origin.y = CGRectGetMaxY(self.progressView.frame) + 15;
    self.labPro.frame = lbRect;
    
#elif 1
    // 2.通过中心点位置设置指示器 的位置
    // 比例
    CGFloat x = (1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount) *(KSCREEN_W- 40);
    NSLog(@"%f",x);
    CGFloat isW  = (x == self.progressView.frame.size.width) ? -20 : 20;    
    // 通过设置中心点
    self.labPro.center = CGPointMake(value * (KSCREEN_W - 40) + isW, CGRectGetMaxY(self.progressView.frame) + 20);
#endif
    
    
    //当前指示值的
    self.labPro.text = [NSString stringWithFormat:@"%.2f%%",(1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount)*100];
    // 进度条的当前值
    CGFloat progressF = 1.0 * self.progress.completedUnitCount / self.progress.totalUnitCount;
    [self.progressView setProgress:progressF animated:YES];
}
@end
