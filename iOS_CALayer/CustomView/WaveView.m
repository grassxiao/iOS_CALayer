//
//  BezierView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/17.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "WaveView.h"
#import "ProxyDisplayLink.h"

@interface WaveView()
@property (nonatomic,strong) CAShapeLayer* bezierShapeLayer;
@property (nonatomic,strong) CADisplayLink* displayLink;
@end

@implementation WaveView

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
    [self.displayLink invalidate];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

-(void)createSelf{
    
    self.clipsToBounds = YES;
    
    self.bezierShapeLayer = [CAShapeLayer layer];
    self.bezierShapeLayer.lineWidth = 5;
    self.bezierShapeLayer.strokeColor = [[UIColor redColor] CGColor];
    self.bezierShapeLayer.fillColor = [[UIColor redColor] CGColor];

    [self.layer addSublayer:self.bezierShapeLayer];
    
    __weak typeof(self) weakSelf = self;
    self.displayLink = [ProxyDisplayLink proxyDisplayLink:^{
        [weakSelf displayUpdate];
    }];
    self.displayLink.preferredFramesPerSecond = 60;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    CGRect bounds = self.bounds;
    UIBezierPath* path = [UIBezierPath bezierPath];
    NSUInteger amplitude = 25;
    NSUInteger height = bounds.size.height;
    NSUInteger width = bounds.size.width;
    
    [path moveToPoint:CGPointMake(0, height/2)];
    [path addQuadCurveToPoint:CGPointMake(width/2, height/2) controlPoint:CGPointMake(width/4, height/2+amplitude)];
    [path addQuadCurveToPoint:CGPointMake(width, height/2) controlPoint:CGPointMake(width*3/4, height/2-amplitude)];
    [path addQuadCurveToPoint:CGPointMake(width*3/2, height/2) controlPoint:CGPointMake(width*5/4, height/2+amplitude)];
    [path addQuadCurveToPoint:CGPointMake(width*2, height/2) controlPoint:CGPointMake(width*7/4, height/2-amplitude)];
   
    [path addLineToPoint:CGPointMake(width*2, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    [path closePath];

    self.bezierShapeLayer.path = path.CGPath;
}

-(void)displayUpdate{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    static NSInteger offset = 0;
    offset -= 5;
    if (offset < -self.bounds.size.width) {
        offset = 0;
    }
    self.bezierShapeLayer.transform = CATransform3DMakeTranslation(offset, 0, 0);
    [CATransaction commit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
