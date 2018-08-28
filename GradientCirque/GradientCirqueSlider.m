//
//  GradientCirqueSlider.m
//  Flame Grace
//
//  Created by Flame Grace on 2017/7/12.
//  Copyright © 2017年 Flame Grace. All rights reserved.
//

#import "GradientCirqueSlider.h"

@interface GradientCirqueSlider() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation GradientCirqueSlider


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    if(self = [super initWithFrame:frame lineWidth:lineWidth])
    {
        _enabled = YES;
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        self.pan.delegate = self;
        [self addGestureRecognizer:self.pan];
    }
    return self;
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

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    self.pan.enabled = enabled;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if([self panAreaContainsPoint:point])
    {
        return YES;
    }
    return NO;
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

- (BOOL)panAreaContainsPoint:(CGPoint)point
{
    double dx = fabs(point.x - [self width]/2.0);
    double dy = fabs(point.y - [self width]/2.0);
    double dis = hypot(dx, dy);
    double radius = [self width]/2.0 - self.lineWidth*2 - self.margin;
    double radius2 = [self width]/2.0 - self.margin + self.lineWidth;
    if(dis >= radius && dis <= radius2)
    {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects]firstObject];
    CGPoint point = [touch locationInView:self];
    if([self panAreaContainsPoint:point])
    {
        [self updateProgressByTouchPoint:point isPan:NO];
    }
}

- (void)updateProgressByTouchPoint:(CGPoint)point isPan:(BOOL)isPan
{
    CGFloat degrees = [self degressByPoint:point];
    
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
        CGFloat reduce = fabs(percent - self.progress);
        //防止超过progress到达0或到达1后继续滑动导致的跳变为1或0
        if(reduce > 0.9)
        {
            return;
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
