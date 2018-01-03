//
//  HeadlineWaitingView.h
//  iOS_CALayer
//
//  Created by apple on 2018/1/1.
//  Copyright © 2018年 grass. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HeadlineWaitingView : UIView
@property(nonatomic,assign) CGFloat progress;
-(void)startAni;
-(void)stopAni;
@end
