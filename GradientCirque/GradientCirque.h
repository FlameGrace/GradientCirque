//
//  Circle.h
//  YKL
//
//  Created by Flame Grace on 15/12/7.
//  Copyright © 2015年 Flame Grace. All rights reserved.
//

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define radiansToDegrees(x) ((x)*180.0/M_PI) //把弧度转换成角度的方式

#import <UIKit/UIKit.h>

@interface GradientCirque : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;

@property (strong, nonatomic) UIColor *backStrokeColor;
//[NSArray arrayWithObjects:(id)[RGB(255, 151, 0) CGColor],(id)[RGB(255, 203, 0) CGColor], nil];
@property (strong, nonatomic) NSArray *gradientColors;

@property (strong, nonatomic) UIImage *endPointImage;
//角度
@property (assign, nonatomic) CGFloat startAngle;
//角度
@property (assign, nonatomic) CGFloat endAngle;

@property (assign, nonatomic) CGFloat margin;

@property (assign,nonatomic) float progress;

@property (assign,nonatomic) CGFloat lineWidth;

- (BOOL)containPoint:(CGPoint)point;

- (CGFloat)width;

- (CGFloat)height;

- (CGRect)frame;

@end
