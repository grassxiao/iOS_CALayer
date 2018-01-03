//
//  HeadlineWaitingView.m
//  iOS_CALayer
//
//  Created by apple on 2018/1/1.
//  Copyright © 2018年 grass. All rights reserved.
//

#import "HeadlineWaitingView.h"
#import "ProxyDisplayLink.h"

typedef NS_ENUM(NSUInteger,ANI_ROTATE){
    ANI_ROTATE_LEFT_TOP = 0,
    ANI_ROTATE_RIGHT_TOP,
    ANI_ROTATE_RIGHT_BOTTOM,
    ANI_ROTATE_LEFT_BOTTOM,
    ANI_ROTATE_COUNT,
};

@interface HeadlineWaitingView()
{
    CGFloat _innerOffset;
    ANI_ROTATE _aniRotate;
}

@property(nonatomic, strong) CAShapeLayer* outerRectLayer;
@property(nonatomic, strong) CAShapeLayer* innerRectLayer;
@property(nonatomic, strong) CAShapeLayer* innerRectMaskLayer;
@property(nonatomic, strong) CAShapeLayer* lineLayer1;
@property(nonatomic, strong) CAShapeLayer* lineLayer2;
@property(nonatomic, assign) CGFloat lineWidth;
@property (nonatomic,strong) CADisplayLink* displayLink;
@end

@implementation HeadlineWaitingView

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
    [self stopAni];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}


-(void)setProgress:(CGFloat)progress{
    _progress = MIN(MAX(progress, 0), 1);
    _aniRotate = ANI_ROTATE_LEFT_TOP;
    
    _outerRectLayer.strokeEnd = progress;
    _innerRectMaskLayer.path = [self genInnerRectMaskPath:MIN(1, progress*3)].CGPath;
    _lineLayer1.strokeEnd = MIN(1, progress*3-1);
    _lineLayer2.strokeEnd = MIN(1, progress*3-2);
}


-(void)createSelf{
    
    _aniRotate = ANI_ROTATE_LEFT_TOP;
    self.outerRectLayer = [CAShapeLayer layer];
    _outerRectLayer.strokeColor = [UIColor grayColor].CGColor;
    _outerRectLayer.lineWidth = 4;
    _outerRectLayer.strokeEnd = 0;
    _outerRectLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_outerRectLayer];
    
    self.innerRectMaskLayer = [CAShapeLayer layer];
    _innerRectMaskLayer.strokeColor = [UIColor grayColor].CGColor;
    _innerRectMaskLayer.lineWidth = 1;
    _innerRectMaskLayer.strokeEnd = 1;
    _innerRectMaskLayer.fillColor = [UIColor grayColor].CGColor;
    
    self.innerRectLayer = [CAShapeLayer layer];
    _innerRectLayer.strokeColor = [UIColor grayColor].CGColor;
    _innerRectLayer.lineWidth = 4;
    _innerRectLayer.strokeEnd = 1;
    _innerRectLayer.fillColor = [UIColor grayColor].CGColor;
    _innerRectLayer.mask = _innerRectMaskLayer;
    [self.layer addSublayer:_innerRectLayer];
    
    self.lineLayer1 = [CAShapeLayer layer];
    _lineLayer1.strokeColor = [UIColor grayColor].CGColor;
    _lineLayer1.lineWidth = 4;
    _lineLayer1.strokeEnd = 0;
    _lineLayer1.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_lineLayer1];
    
    self.lineLayer2 = [CAShapeLayer layer];
    _lineLayer2.strokeColor = [UIColor grayColor].CGColor;
    _lineLayer2.lineWidth = 4;
    _lineLayer2.strokeEnd = 0;
    _lineLayer2.fillColor = [UIColor clearColor].CGColor;
    _lineLayer2.contentsGravity = kCAGravityResizeAspectFill;
    [self.layer addSublayer:_lineLayer2];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = MAX(2, lineWidth);
    _outerRectLayer.lineWidth = _lineWidth;
    _innerRectLayer.lineWidth = _lineWidth;
    _lineLayer1.lineWidth = _lineWidth;
    _lineLayer2.lineWidth = _lineWidth;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    
    CGFloat minLength = MIN(self.bounds.size.width, self.bounds.size.height);
    _innerOffset = MAX(4, minLength/20);
    self.lineWidth = minLength/80;
    minLength -= 2 * _innerOffset;
    
    CGFloat cornerRadius = MAX(3, minLength / 40);
    
    CGFloat x = (self.bounds.size.width - minLength ) / 2;
    CGFloat y = (self.bounds.size.height - minLength ) / 2;
    
    _outerRectLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, minLength, minLength) cornerRadius:cornerRadius].CGPath;
    
    [self genInnerPathWithAniRotate];
}

-(void)genInnerPathWithAniRotate{
    
    CGFloat minLength = MIN(self.bounds.size.width, self.bounds.size.height);
    minLength -= 6 * _innerOffset;
    CGFloat x = (self.bounds.size.width - minLength ) / 2;
    CGFloat y = (self.bounds.size.height - minLength ) / 2;
    CGFloat lineOffset = minLength/5;

    if(_aniRotate == ANI_ROTATE_LEFT_TOP){
        _innerRectLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, lineOffset*2, lineOffset*2)].CGPath;
        
        CGFloat lineX = x + minLength /2 + _innerOffset;
        
        UIBezierPath* path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(lineX, y)];
        [path1 addLineToPoint:CGPointMake(x+minLength, y)];
        
        [path1 moveToPoint:CGPointMake(lineX, y+lineOffset)];
        [path1 addLineToPoint:CGPointMake(x+minLength,  y+lineOffset)];
        
        [path1 moveToPoint:CGPointMake(lineX,  y+lineOffset*2)];
        [path1 addLineToPoint:CGPointMake(x+minLength,  y+lineOffset*2)];
        
        _lineLayer1.path = path1.CGPath;
        
        CGFloat line2Y = y + 3*lineOffset;
        
        UIBezierPath* path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(x, line2Y)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset*2)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset*2)];
        
        _lineLayer2.path = path2.CGPath;
    }
    else if(_aniRotate == ANI_ROTATE_RIGHT_TOP){
        _innerRectLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(x+minLength-lineOffset*2, y, lineOffset*2, lineOffset*2)].CGPath;
        
        CGFloat lineX = x ;
        CGFloat lineY = y ;

        UIBezierPath* path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(lineX, lineY)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset, lineY)];
        
        [path1 moveToPoint:CGPointMake(lineX, lineY+lineOffset)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset,  lineY+lineOffset)];
        
        [path1 moveToPoint:CGPointMake(lineX,  lineY+lineOffset*2)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset,  lineY+lineOffset*2)];
        
        _lineLayer2.path = path1.CGPath;
        
        CGFloat line2Y = y + 3*lineOffset;

        UIBezierPath* path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(x, line2Y)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset*2)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset*2)];
        
        _lineLayer1.path = path2.CGPath;
    }
    else if(_aniRotate == ANI_ROTATE_RIGHT_BOTTOM){
        
        CGFloat lineX = x;
        CGFloat lineY = y + 3*lineOffset;
        
        _innerRectLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(x+minLength-2*lineOffset, lineY, lineOffset*2, lineOffset*2)].CGPath;


        UIBezierPath* path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(lineX, lineY)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset, lineY)];
        
        [path1 moveToPoint:CGPointMake(lineX, lineY+lineOffset)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset,  lineY+lineOffset)];
        
        [path1 moveToPoint:CGPointMake(lineX,  lineY+lineOffset*2)];
        [path1 addLineToPoint:CGPointMake(x+minLength/2-_innerOffset,  lineY+lineOffset*2)];
        
        _lineLayer1.path = path1.CGPath;
        
        CGFloat line2Y = y;
        
        UIBezierPath* path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(x, line2Y)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset*2)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset*2)];
        
        _lineLayer2.path = path2.CGPath;
    }
    else if(_aniRotate == ANI_ROTATE_LEFT_BOTTOM){
        
        CGFloat lineX = x + minLength /2 + _innerOffset;
        CGFloat lineY = y + 3*lineOffset;

        _innerRectLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(x, lineY, lineOffset*2, lineOffset*2)].CGPath;
        
        UIBezierPath* path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(lineX, lineY)];
        [path1 addLineToPoint:CGPointMake(x+minLength, lineY)];
        
        [path1 moveToPoint:CGPointMake(lineX, lineY+lineOffset)];
        [path1 addLineToPoint:CGPointMake(x+minLength, lineY+lineOffset)];
        
        [path1 moveToPoint:CGPointMake(lineX,  lineY+lineOffset*2)];
        [path1 addLineToPoint:CGPointMake(x+minLength, lineY+lineOffset*2)];
        
        _lineLayer2.path = path1.CGPath;
        
        CGFloat line2Y = y;
        
        UIBezierPath* path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(x, line2Y)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset)];
        
        [path2 moveToPoint:CGPointMake(x, line2Y+lineOffset*2)];
        [path2 addLineToPoint:CGPointMake(x+minLength, line2Y+lineOffset*2)];
        
        _lineLayer1.path = path2.CGPath;
    }
}

-(UIBezierPath*)genInnerRectMaskPath:(CGFloat)progress{
    
    CGFloat startAngle = M_PI*5/4;
    CGFloat endAngle = startAngle + (2 * M_PI-0.01) * progress ;
    endAngle = endAngle > 2 * M_PI ? endAngle - 2 * M_PI : endAngle ;
    
    CGRect rect = CGPathGetBoundingBox(_innerRectLayer.path) ;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    UIBezierPath* path =  [UIBezierPath bezierPathWithArcCenter:center
                                           radius:radius
                                       startAngle:startAngle
                                         endAngle:endAngle
                                        clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    return path;
}

-(void)startAni{
    self.progress = 1.f;
    _aniRotate = ANI_ROTATE_LEFT_TOP;
    
    __weak typeof(self) weakSelf = self;
    self.displayLink = [ProxyDisplayLink proxyDisplayLink:^{
        [weakSelf updateAni];
    }];
    self.displayLink.preferredFramesPerSecond = 2;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)updateAni{
    _aniRotate = (_aniRotate + 1) % ANI_ROTATE_COUNT;
    [self genInnerPathWithAniRotate];
    [self.innerRectLayer addAnimation:[self pathAnimationWithDuration:0.333] forKey:@"innerRectLayer"];
    [self.lineLayer1 addAnimation:[self pathAnimationWithDuration:0.15] forKey:@"lineLayer1"];
    [self.lineLayer2 addAnimation:[self pathAnimationWithDuration:0.15] forKey:@"lineLayer2"];
}

- (CABasicAnimation *)pathAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = duration;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
}

-(void)stopAni{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
