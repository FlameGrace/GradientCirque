//
//  GradientCirque.m
//  Flame Grace
//
//  Created by Flame Grace on 2017/7/12.
//  Copyright © 2017年 Flame Grace. All rights reserved.

#import "GradientCirque.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface GradientCirque ()

@property (strong, nonatomic) CAShapeLayer* backLayer;
@property (strong, nonatomic) CAShapeLayer* progressLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIImageView *endPoint;//在终点位置添加一个点
@property (strong, nonatomic) UIBezierPath *path;
@property (assign, nonatomic) CGFloat cacheWidth;
@property (assign, nonatomic) CGFloat cacheHeight;
@property (assign, nonatomic) CGRect cacheFrame;
@end

@implementation GradientCirque


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _cacheWidth = frame.size.width;
        _cacheHeight = frame.size.height;
        _cacheFrame = frame;
        _lineWidth = lineWidth;
        _backStrokeColor = [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1];
        _gradientColors = [NSArray arrayWithObjects:(id)[RGB(255, 151, 0) CGColor],(id)[RGB(255, 203, 0) CGColor], nil];
        _startAngle = 0;
        _endAngle = 360;
        _endPointMargin = 1.0f;
        [self layoutLayers];
        self.progress = 0;
    }
    return self;
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self layoutLayers];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self layoutLayers];
}

- (void)setBackStrokeColor:(UIColor *)backStrokeColor
{
    _backStrokeColor = backStrokeColor;
    [self layoutLayers];
}

- (void)setGradientColors:(NSArray *)gradientColors
{
    _gradientColors = gradientColors;
    [self layoutLayers];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self layoutLayers];
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    [self layoutLayers];
}

- (void)setEndPointImage:(UIImage *)endPointImage
{
    _endPointImage = endPointImage;
    self.endPoint.image = endPointImage;
}

- (void)setEndPointMargin:(CGFloat)endPointMargin
{
    _endPointMargin = endPointMargin;
    [self updateEndPoint];
}

- (void)setHideEndPoint:(BOOL)hideEndPoint
{
    _hideEndPoint = hideEndPoint;
    self.endPoint.hidden = hideEndPoint;
}

- (void)layoutLayers
{
    [self.backLayer removeFromSuperlayer];
    [self.progressLayer removeFromSuperlayer];
    [self.gradientLayer removeFromSuperlayer];
    
    float centerX = _cacheWidth/2.0;
    float centerY = _cacheHeight/2.0;
    //半径
    float radius = (_cacheWidth-_lineWidth)/2.0 - _margin;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    _path = path;
    //添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = _cacheFrame;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = _backStrokeColor.CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.lineCap = kCALineCapRound;
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    self.backLayer = backLayer;
    
    //创建进度layer
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = _cacheFrame;
    progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    progressLayer.strokeColor  = [UIColor blackColor].CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = _lineWidth;
    progressLayer.path = [path CGPath];
    progressLayer.strokeEnd = self.progress;
    self.progressLayer = progressLayer;
    
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = _cacheFrame;
    [gradientLayer setColors:_gradientColors];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:self.progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    [self updateEndPoint];
}


-(void)setProgress:(float)progress
{
    if(_progress == progress)
    {
        return;
    }
    if(progress < 0)
    {
        progress = 0;
    }
    if(progress > 1)
    {
        progress = 1;
    }
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [self updateEndPoint];
    [_progressLayer removeAllAnimations];
}

- (BOOL)containPoint:(CGPoint)point
{
    double dx = fabs(point.x - _cacheWidth/2.0);
    double dy = fabs(point.y - _cacheHeight/2.0);
    double dis = hypot(dx, dy);
    double radius = _cacheWidth/2.0 - _lineWidth - _margin;
    double radius2 = _cacheWidth/2.0 - _margin;
    BOOL contain = NO;
    if(dis >= radius && dis <= radius2)
    {
        CGFloat degress = [self degressByPoint:point];
        if(degress >= self.startAngle && degress <= self.endAngle)
        {
            contain =  YES;
        }
    }
    return contain;
}

- (CGFloat)degressByPoint:(CGPoint)point
{
    float radius = _cacheWidth/2.0;
    CGFloat x =  point.x - radius;
    CGFloat y =  point.y - radius;
    CGFloat radians = atan(y/x);
    if(x<0)
    {
        radians -= M_PI;
    }
    CGFloat degrees = radiansToDegrees(radians);
    if(degrees < self.startAngle && degrees + 360 < self.endAngle)
    {
        degrees += 360;
    }
    if(degrees > self.startAngle + 360)
    {
        degrees -= 360;
    }
    return degrees;
}

//更新小点的位置
-(void)updateEndPoint
{
    if(_hideEndPoint)
    {
        return;
    }
    float radius = (_cacheWidth-_lineWidth)/2.0 -_margin;
    CGFloat d = (self.endAngle - self.startAngle)*_progress + self.startAngle;
    CGFloat radians = degreesToRadians(d);
    
    CGFloat moveX =  radius*cosf(radians);
    CGFloat moveY =  radius*sinf(radians);
    
    CGFloat x = radius + moveX + _margin;
    CGFloat y = radius + moveY + _margin;
    //更新圆环的frame
    CGRect rect = CGRectMake(x + _endPointMargin, y + _endPointMargin, _lineWidth - _endPointMargin*2,_lineWidth - _endPointMargin*2);
    self.endPoint.frame = rect;
    self.endPoint.layer.cornerRadius = rect.size.width/2;
    //移动到最前
    [self bringSubviewToFront:self.endPoint];
    
}

- (CGFloat)width
{
    return _cacheWidth;
}

- (CGFloat)height
{
    return _cacheHeight;
}

- (CGRect)frame
{
    return _cacheFrame;
}

- (UIImageView *)endPoint
{
    if(!_endPoint)
    {
        //用于显示结束位置的小点
        _endPoint = [[UIImageView alloc] init];
        _endPoint.backgroundColor = [UIColor whiteColor];
        [self addSubview:_endPoint];
        _endPoint.layer.masksToBounds = YES;
        _endPoint.hidden = self.hideEndPoint;
    }
    return _endPoint;
}

@end

