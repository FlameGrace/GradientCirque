//
//  GradientCirqueSlider.h
//  Flame Grace
//
//  Created by Flame Grace on 2017/7/12.
//  Copyright © 2017年 Flame Grace. All rights reserved.
//

#import "GradientCirque.h"

@class GradientCirqueSlider;

@protocol GradientCirqueSliderDelegate <NSObject>

@optional
- (void)gradientCirqueSliderTouchStart:(GradientCirqueSlider *)cirque;

- (void)gradientCirqueSliderTouchMove:(GradientCirqueSlider *)cirque;

- (void)gradientCirqueSliderTouchEnd:(GradientCirqueSlider *)cirque;

- (void)gradientCirqueSliderValueChanged:(GradientCirqueSlider *)cirque;

@end


@interface GradientCirqueSlider : GradientCirque <GradientCirqueSliderDelegate>

@property (weak, nonatomic) id <GradientCirqueSliderDelegate>delegate;

@property (assign, nonatomic) CGFloat minValue;
@property (assign, nonatomic) CGFloat maxValue;
@property (assign, nonatomic) CGFloat value;
@property (assign, nonatomic) BOOL enabled;

@end
