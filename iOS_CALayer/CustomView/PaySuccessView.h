//
//  PaySuccessView.h
//  iOS_CALayer
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 grass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(void);

IB_DESIGNABLE
@interface PaySuccessView : UIView

@property (nonatomic, assign) CGFloat circleWidth; //default 5
@property (nonatomic, assign) CGFloat tickWidth; //default 5
@property (nonatomic, assign) CGFloat aniDuration; //total ani duration, default 2 second, 1 second circle ani, 1 second tick ani
@property (nonatomic) CGColorRef circleColor; //default green
@property (nonatomic) CGColorRef tickColor; //default green

-(void)startAniWithComplete:(CompleteBlock)block;
@end
