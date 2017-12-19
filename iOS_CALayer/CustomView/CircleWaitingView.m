//
//  CircleWaitingView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/17.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "CircleWaitingView.h"

@interface CircleWaitingView()
@property (nonatomic,strong) CAReplicatorLayer* replicatorLayer;
@property (nonatomic,strong) CAShapeLayer* circleLayer;
@end

@implementation CircleWaitingView

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
        
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.strokeColor = [UIColor redColor].CGColor;
    self.circleLayer.fillColor = [UIColor redColor].CGColor;
    self.circleLayer.lineCap = kCALineCapRound;
    
    self.replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer.instanceCount = 1;
    self.replicatorLayer.preservesDepth = YES;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(2*M_PI/40, 0, 0, 1);
    self.replicatorLayer.instanceDelay = 0.1;

    [self.replicatorLayer addSublayer:self.circleLayer];
    [self.layer addSublayer:self.replicatorLayer];
    
//    CAKeyframeAnimation* ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    ani.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)]];
//    ani.repeatCount = HUGE;
//    ani.fillMode = kCAFillModeBoth;

    CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.duration = 4;
    ani.repeatCount = HUGE;
    ani.fillMode = kCAFillModeBoth;
    ani.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    ani.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    
    CABasicAnimation* alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAni.duration = 4;
    alphaAni.repeatCount = HUGE;
    alphaAni.fillMode = kCAFillModeBoth;
    alphaAni.fromValue = @1;
    alphaAni.toValue = @0;
    
    [self.circleLayer addAnimation:ani forKey:@"circleAni"];
    [self.circleLayer addAnimation:alphaAni forKey:@"alphaAni"];
    
    CABasicAnimation* countAni = [CABasicAnimation animationWithKeyPath:@"instanceCount"];
    countAni.removedOnCompletion = NO;
    countAni.duration = 4;
    countAni.repeatCount = 1;
    countAni.fillMode = kCAFillModeBoth;
    countAni.fromValue = @1;
    countAni.toValue = @41;
    [self.replicatorLayer addAnimation:countAni forKey:@"countAni"];
    
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat radius = 10;
    
    self.replicatorLayer.frame = self.bounds;
    self.circleLayer.position = CGPointMake(self.bounds.size.width/2+MIN(width, height)/2-radius, height/2);
    self.circleLayer.bounds = CGRectMake(0, 0, radius*2, radius*2);
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.circleLayer.path = path.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
