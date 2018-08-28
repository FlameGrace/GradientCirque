//
//  ViewController.m
//  Demo
//
//  Created by Flame Grace on 2017/9/7.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//

#import "ViewController.h"
#import "GradientCirqueSlider.h"

@interface ViewController () <GradientCirqueSliderDelegate>

@property (strong, nonatomic) GradientCirqueSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider = [[GradientCirqueSlider alloc]initWithFrame:CGRectMake(0, 0, 200, 200) lineWidth:20];
    self.slider.maxValue = 30;
    self.slider.minValue = 10;
    self.slider.margin = 15;
//    self.slider.startAngle = 0;
//    self.slider.endAngle = 360;
    self.slider.endPointMargin = 3;
    self.slider.startAngle = -225;
    self.slider.endAngle = 45;
    self.slider.delegate = self;
    self.slider.center = self.view.center;
    self.slider.layer.cornerRadius = 100;
    self.slider.layer.shadowColor = [UIColor blueColor].CGColor;
    self.slider.layer.shadowOffset = CGSizeZero;
    self.slider.layer.shadowOpacity = 0.4;
    self.slider.backgroundColor = [UIColor whiteColor];
    self.slider.layer.shadowRadius = 8;
    [self.view addSubview:self.slider];
}

- (void)gradientCirqueSliderValueChanged:(GradientCirqueSlider *)cirque
{
    
}


@end
