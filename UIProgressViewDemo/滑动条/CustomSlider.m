//
//  CustomSlider.m
//  UIProgressViewDemo
//
//  Created by knight on 2018/8/4.
//  Copyright © 2018年 knight. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

#pragma mark  - 重写setter
- (CGRect) minimumValueImageRectForBounds:(CGRect)bounds
{
    //[super minimumValueImageRectForBounds:bounds];
    
    CGRect minFrame = bounds;
    minFrame.origin.y  += 15;
    minFrame.origin.x = 30;//self.frame.origin.x;
    minFrame.size.width = 32;
    minFrame.size.height = 32;
//    self.frame =  minFrame;
    return minFrame;
}

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;
{
    //NSLog(@"%@",self.subviews);
    CGRect currRect = CGRectZero;
    
//    UIView * vv = [self.subviews objectAtIndex:0];
//    currRect = vv.frame;
    for (UIView * defaultV in self.subviews) {
        if (![defaultV isKindOfClass:[UIImageView class]]) {
            UIView * vvvv = (UIView *)defaultV;
            currRect = vvvv.frame;
            //NSLog(@"这个image? %@",vvvv);
        }
    }
    CGRect maxFrame = bounds;
    maxFrame.origin.y  += 15;
    maxFrame.origin.x = CGRectGetMaxX(currRect)-42;
    maxFrame.size.width = 42;
    maxFrame.size.height = 30;
    return maxFrame;
}
//- (CGRect)trackRectForBounds:(CGRect)bounds;
//{
//    return bounds;
//}
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;
//{
//    return bounds;
//}
@end
