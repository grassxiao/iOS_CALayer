//
//  RainView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "RainView.h"

@interface RainView()
@property (nonatomic,strong) CAEmitterLayer* emitterLayer;
@end

@implementation RainView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createSelf];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSelf];
    }
    
    return self;
}

-(void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

-(void)createSelf{
    self.backgroundColor = [UIColor blackColor];
    self.emitterLayer = [CAEmitterLayer layer];
    //发射位置
    _emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, 0);
    //发射源的大小
    _emitterLayer.emitterSize = CGSizeMake(self.bounds.size.width, 1);
    //发射源的形状
    _emitterLayer.emitterMode = kCAEmitterLayerSurface;
    //发射模式
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
    
    //存放粒子种类的数组
    NSMutableArray *rain_array = @[].mutableCopy;
    
    for (NSInteger i=1; i<5; i++) {
        //snow
        CAEmitterCell *rainCell = [CAEmitterCell emitterCell];
        rainCell.name = @"rain";
        //产生频率
        rainCell.birthRate = 15.0f;
        //生命周期
        rainCell.lifetime = 5.0f;
        //运动速度
        rainCell.velocity = -100.0f;
        //运动速度的浮动值
        rainCell.velocityRange = 20;
        //y方向的加速度
        rainCell.yAcceleration = 200;
        rainCell.xAcceleration = 5;
        //抛洒角度的浮动值
//        rainCell.emissionRange = 0.1*M_PI;
        //自旋转角度范围
//        rainCell.spinRange = 0.25*M_PI;
        //粒子透明度在生命周期内的改变速度
        rainCell.alphaSpeed = 2.0f;
        //cell的内容，一般是图片
        rainCell.contents = (__bridge id)[self createImageWithColor:[UIColor whiteColor]].CGImage;
        
        [rain_array addObject:rainCell];
    }
    
    _emitterLayer.emitterCells = [NSArray arrayWithArray:rain_array];
    [self.layer addSublayer:_emitterLayer];
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect= CGRectMake(0.0f,0.0f,4.0f,4.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *theImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
