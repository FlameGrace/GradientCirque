//
//  GradientCirque.h
//  Flame Grace
//
//  Created by Flame Grace on 2017/7/12.
//  Copyright © 2017年 Flame Grace. All rights reserved.
// 渐变圆环，可以设置进度

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define radiansToDegrees(x) ((x)*180.0/M_PI) //把弧度转换成角度的方式

#import <UIKit/UIKit.h>

@interface GradientCirque : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;
//圆环背景颜色
@property (strong, nonatomic) UIColor *backStrokeColor;
//圆环渐变颜色
@property (strong, nonatomic) NSArray *gradientColors;
//是否隐藏终点小圆点
@property (assign, nonatomic) BOOL hideEndPoint;
//终点的小圆点边界与圆环的边距
@property (assign, nonatomic) CGFloat endPointMargin;
//终点的小圆点
@property (strong, nonatomic) UIImage *endPointImage;
//起始角度
@property (assign, nonatomic) CGFloat startAngle;
//终止角度
@property (assign, nonatomic) CGFloat endAngle;
//圆环边距
@property (assign, nonatomic) CGFloat margin;
//进度
@property (assign,nonatomic) CGFloat progress;
//圆环宽度
@property (assign,nonatomic) CGFloat lineWidth;
//某个点是否在lineWidth的圆环上
- (BOOL)containPoint:(CGPoint)point;

@end
