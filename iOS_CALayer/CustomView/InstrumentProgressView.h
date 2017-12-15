//
//  InstrumentProgressView.h
//  iOS_CALayer
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 grass. All rights reserved.
//


#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface InstrumentProgressView : UIView

//进度值，取值[0-1]
@property (nonatomic, readonly) CGFloat progress;

//设置起始角度和结束角度，取值(0-360)之间
-(void)setStartDegrees:(NSUInteger)startDegrees andEndDegrees:(NSUInteger)endDegrees;
-(void)setProgress:(CGFloat)progress withAni:(BOOL)ani;
@end

