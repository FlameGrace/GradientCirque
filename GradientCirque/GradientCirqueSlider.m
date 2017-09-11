//
//  GradientCirqueSlider.m
//  leapmotor
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
    if(enabled)
    {
        [self removeGestureRecognizer:self.pan];
        [self addGestureRecognizer:self.pan];
    }
    else
    {
        [self removeGestureRecognizer:self.pan];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
    [self updateTemperatureByTouchPoint:point];
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
    if([self containPoint:point])
    {
        [self updateTemperatureByTouchPoint:point];
    }
    
}

- (void)updateTemperatureByTouchPoint:(CGPoint)point
{
    float radius = (self.width-self.lineWidth)/2.0 - self.margin;
    CGFloat x =  point.x - radius;
    CGFloat y =  point.y - radius;
    CGFloat radians = atan(y/x);
    if(x<0)
    {
        radians -= M_PI;
    }
    CGFloat degrees = radiansToDegrees(radians);
    if(degrees<self.startAngle || degrees>self.endAngle)
    {
        return;
    }
    CGFloat percent = (degrees-self.startAngle)/(self.endAngle- self.startAngle);
    
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
