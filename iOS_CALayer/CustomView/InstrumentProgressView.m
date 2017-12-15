//
//  InstrumentProgressView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 grass. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "InstrumentProgressView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radius) ((radius) / M_PI * 180.0)
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define ProgressStartAngle 144
#define ProgressEndAngle  396


@interface InstrumentProgressView ()
@property(nonatomic, assign)NSUInteger startDegrees;
@property(nonatomic, assign)NSUInteger endDegrees;
@property(nonatomic, strong)CAShapeLayer * progressMaskLayer;
@property(nonatomic, strong)CAShapeLayer * backgroudLayer;
@property(nonatomic, strong)CAGradientLayer* gradientLayer;
@property (nonatomic, readwrite) CGFloat progress;
@end


@implementation InstrumentProgressView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self creatSelf];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSelf];
    }
    
    return self;
}

-(void)dealloc{
    NSLog(@"dealloc");
}

-(void)creatSelf{
    self.backgroudLayer = [CAShapeLayer layer];
    _backgroudLayer.fillColor =  [[UIColor clearColor] CGColor];
    _backgroudLayer.strokeColor  = [UIColorFromRGB(0x4a4757) CGColor];
    _backgroudLayer.lineCap = kCALineCapRound;
    _backgroudLayer.lineWidth = 5;
    
    [self.layer addSublayer:_backgroudLayer];
    
    self.progressMaskLayer = [CAShapeLayer layer];
    _progressMaskLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressMaskLayer.strokeColor  = [[UIColor redColor] CGColor];
    _progressMaskLayer.lineCap = kCALineCapRound;
    _progressMaskLayer.lineWidth = 10;
    _progressMaskLayer.strokeEnd = 1.f;
    
    self.gradientLayer =  [CAGradientLayer layer];
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x7735ff) CGColor],(id)[UIColorFromRGB(0x1ed1ff) CGColor], nil]];
    [_gradientLayer setStartPoint:CGPointMake(0, 1)];
    [_gradientLayer setEndPoint:CGPointMake(0, 0)];
    _gradientLayer.type = kCAGradientLayerAxial;
    [_gradientLayer setMask:_progressMaskLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
    
    [self setStartDegrees:ProgressStartAngle andEndDegrees:ProgressEndAngle];
}

-(void)setStartDegrees:(NSUInteger)startDegrees andEndDegrees:(NSUInteger)endDegrees{
    self.startDegrees = startDegrees > 360 ? startDegrees%360 : startDegrees;
    self.endDegrees = endDegrees > 360 ? endDegrees%360 : endDegrees;
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f;
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:radius-10
                                                      startAngle:DEGREES_TO_RADIANS(startDegrees)
                                                        endAngle:DEGREES_TO_RADIANS(endDegrees)
                                                       clockwise:YES];
    _backgroudLayer.path = [bgPath CGPath];
    UIBezierPath *path = [self genProgressPath:self.progress];
    _progressMaskLayer.path = [path CGPath];
}

-(UIBezierPath*)genProgressPath:(CGFloat)progress{
    CGFloat progressAngle = progress * (2*M_PI - DEGREES_TO_RADIANS(self.startDegrees) + DEGREES_TO_RADIANS(self.endDegrees));
    CGFloat endAngle = (DEGREES_TO_RADIANS(self.startDegrees) + progressAngle);
    if (endAngle > 2*M_PI) {
        endAngle -= 2*M_PI;
    }
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f;
    return  [UIBezierPath bezierPathWithArcCenter:center
                                           radius:radius-10
                                       startAngle:DEGREES_TO_RADIANS(self.startDegrees)
                                         endAngle:endAngle
                                        clockwise:YES];
}


-(void)layoutSublayersOfLayer:(CALayer *)layer{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:radius-10
                                                      startAngle:DEGREES_TO_RADIANS(self.startDegrees)
                                                        endAngle:DEGREES_TO_RADIANS(self.endDegrees)
                                                       clockwise:YES];
    _backgroudLayer.path = [bgPath CGPath];
    _gradientLayer.frame = self.bounds;
    _progressMaskLayer.frame = self.bounds;
    UIBezierPath *path = [self genProgressPath:self.progress];
    _progressMaskLayer.path = [path CGPath];
}


-(void)setProgress:(CGFloat)progress withAni:(BOOL)ani{
    _progress = MIN(1.0, MAX(0.0, progress));
    NSUInteger greaterEnd = self.endDegrees < self.startDegrees ? self.endDegrees + 360 : self.endDegrees;
    NSUInteger angle = (greaterEnd - self.startDegrees) * _progress + self.startDegrees;
    angle = angle > 360 ? angle-360 : angle;
    
    CGPoint endPoint = CGPointMake(cos(DEGREES_TO_RADIANS(angle)), sin(DEGREES_TO_RADIANS(angle)));
    CGPoint startPoint = CGPointMake(cos(DEGREES_TO_RADIANS(self.startDegrees)), sin(DEGREES_TO_RADIANS(self.startDegrees)));
    
    [self.gradientLayer setStartPoint:CGPointMake((startPoint.x+1)/2.f, (startPoint.y+1)/2.f)];
    [self.gradientLayer setEndPoint:CGPointMake((endPoint.x+1)/2.f, (endPoint.y+1)/2.f)];
    
    _progressMaskLayer.path = [self genProgressPath:_progress].CGPath;
    if(ani){
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.666f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = @0;
        animation.toValue = @1;
        [_progressMaskLayer addAnimation:animation forKey:@"progress"];
    }
}
@end
