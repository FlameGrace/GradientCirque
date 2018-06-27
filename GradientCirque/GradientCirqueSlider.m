//
//  GradientCirqueSlider.m
//  Flame Grace
//
//  Created by Flame Grace on 2017/7/12.
//  Copyright © 2017年 Flame Grace. All rights reserved.
//

#import "GradientCirqueSlider.h"

@interface GradientCirqueSlider()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation GradientCirqueSlider


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    if(self = [super initWithFrame:frame lineWidth:lineWidth])
    {
        _enabled = YES;
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:self.pan];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    self.pan.enabled = enabled;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
    [self updateProgressByTouchPoint:point isPan:YES];
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        [self gradientCirqueSliderTouchStart:self];
    }
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        [self gradientCirqueSliderTouchMove:self];
    }
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        [self gradientCirqueSliderTouchEnd:self];
    }
}

- (void)gradientCirqueSliderTouchStart:(GradientCirqueSlider *)cirque
{
    if([self.delegate respondsToSelector:@selector(gradientCirqueSliderTouchStart:)])
    {
        [self.delegate gradientCirqueSliderTouchStart:cirque];
    }
}

- (void)gradientCirqueSliderTouchMove:(GradientCirqueSlider *)cirque
{
    if([self.delegate respondsToSelector:@selector(gradientCirqueSliderTouchMove:)])
    {
        [self.delegate gradientCirqueSliderTouchMove:cirque];
    }
}

- (void)gradientCirqueSliderTouchEnd:(GradientCirqueSlider *)cirque
{
    if([self.delegate respondsToSelector:@selector(gradientCirqueSliderTouchEnd:)])
    {
        [self.delegate gradientCirqueSliderTouchEnd:cirque];
    }
}

- (void)gradientCirqueSliderValueChanged:(GradientCirqueSlider *)cirque
{
    if([self.delegate respondsToSelector:@selector(gradientCirqueSliderValueChanged:)])
    {
        [self.delegate gradientCirqueSliderValueChanged:cirque];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects]firstObject];
    CGPoint point = [touch locationInView:self];
    if([self containPoint:point]&&_enabled)
    {
        [self updateProgressByTouchPoint:point isPan:NO];
    }
    
}

- (void)updateProgressByTouchPoint:(CGPoint)point isPan:(BOOL)isPan
{
    CGFloat width = self.frame.size.width;
    float radius = (width-self.lineWidth)/2.0 - self.margin;
    CGFloat x =  point.x - radius;
    CGFloat y =  point.y - radius;
    CGFloat radians = atan(y/x);
    if(x<0)
    {
        radians -= M_PI;
    }
    CGFloat degrees = radiansToDegrees(radians);
    CGFloat maxAngle = self.startAngle + 360;
    if(degrees < self.startAngle)
    {
        degrees += 360;
    }
    if(degrees > maxAngle)
    {
        degrees -= 360;
    }
    CGFloat percent = (degrees-self.startAngle)/(self.endAngle- self.startAngle);
    if(percent < 0)
    {
        percent = 0;
    }
    if(percent > 1)
    {
        percent = 1;
    }
    if(isPan)
    {
        //防止在progress接近0时滑动过快，导致的停顿现象
        if(percent == 1 && self.progress < 0.5)
        {
            percent = 0;
        }
        else
        {
            CGFloat reduce = percent - self.progress;
            if(reduce < 0)
            {
                reduce = self.progress - percent;
            }
            //防止超过progress到达0或到达1后继续滑动导致的跳变为1或0
            if(reduce > 0.9)
            {
                return;
            }
        }
    }
    self.progress = percent;
    [self gradientCirqueSliderValueChanged:self];
}


- (CGFloat)value
{
    return self.progress * (self.maxValue-self.minValue) + self.minValue;
}

- (void)setValue:(CGFloat)value
{
    self.progress = (value-self.minValue)/(self.maxValue-self.minValue);
}


@end
