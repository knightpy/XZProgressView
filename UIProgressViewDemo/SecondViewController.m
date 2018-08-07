//
//  SecondViewController.m
//  UIProgressViewDemo
//
//  Created by knight on 2018/8/6.
//  Copyright © 2018年 knight. All rights reserved.
//
#define KSCREEN_W [UIScreen mainScreen].bounds.size.width
#define KSCREEN_H [UIScreen mainScreen].bounds.size.height

#import "SecondViewController.h"
#import "CustomProgressView.h"
#import "CustomSlider.h"

@interface SecondViewController ()

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
/** weak */
@property (nonatomic,weak) UIButton *btn;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progress = [NSProgress progressWithTotalUnitCount:100];
    //使用KVO观察fractionCompleted的改变
    [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self slideView];
    [self progressView];
    [self labPro];
    [self labMin];
    [self labMax];
    
    UIButton *  my_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    my_Button.frame = CGRectMake((KSCREEN_W - 100)/2, KSCREEN_H - 120, 100, 30);
    [my_Button setTitle:@"请点击我!" forState:UIControlStateNormal];
    [my_Button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal] ;
    [my_Button setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted] ;
    [my_Button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [my_Button addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:my_Button];
    self.btn = my_Button;
    
    
    UIButton *  startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((KSCREEN_W - 100)/2, KSCREEN_H - 180, 100, 30);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal] ;
    [startBtn addTarget:self action:@selector(click_buttonStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void)click_buttonStart
{
    [self addTimer];
}
- (void)click_button:(UIButton *)button
{
    
    button.selected = !button.selected;
    if (button.selected) {
        // 暂停
        // 原理是把触发时间设置在未来，既很久之后，这样定时器自动进入等待触发的状态，估计要等很久。。。
        [self.timer setFireDate:[NSDate distantFuture]];
    }else{
        // 开始：
        //原理是把触发时间设置为现在，设置后定时器马上进入工作状态。
        [self.timer setFireDate:[NSDate date]];
    }
    //button.enabled = NO;
}


/** 定时器调用的方法 */
- (void)task:(NSTimer *)timer
{
    if (self.progress.completedUnitCount >= self.progress.totalUnitCount) {
        [self removeTimer];
        //self.btn.enabled = YES;
//        return;
    }else{
         self.progress.completedUnitCount += 1;
    }
   
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

/**
 *  添加定时器
 */
-(void)addTimer{
    
    //定时器1
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(task:) userInfo:nil repeats:YES];
    //加到当前运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    // 定时器2
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(task:) userInfo:nil repeats:YES];
//    [timer fire];
//    self.timer = timer;
}

/**
 *  移除定时器
 */
-(void)removeTimer{
    [self.timer invalidate];
    //因为定时器停止后则变为无效定时器 所以需要从内存中移除
    self.timer = nil;
    
    //        [timer setFireDate:[NSDate date]];
    //        [timer fireDate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
}
@end
