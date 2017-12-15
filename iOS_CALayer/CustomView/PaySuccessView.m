//
//  PaySuccessView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "PaySuccessView.h"

@interface ProxyAnimationDelegate : NSObject <CAAnimationDelegate>
@property (nonatomic,weak) id<CAAnimationDelegate> delegate;
-(instancetype)initWithDelegate:(id<CAAnimationDelegate>)delegate;
@end

@implementation ProxyAnimationDelegate

-(instancetype)initWithDelegate:(id<CAAnimationDelegate>)delegate{
    self = [super init];
    self.delegate = delegate;
    return self;
}

-(void)dealloc{
    NSLog(@"ProxyAnimationDelegate dealloc");
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    if ([self.delegate respondsToSelector:@selector(animationDidStart:)]) {
        [self.delegate animationDidStart:anim];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(animationDidStop:finished:)]) {
        [self.delegate animationDidStop:anim finished:YES];
    }
}
@end


@interface PaySuccessView()<CAAnimationDelegate>
{
    BOOL _needStartAni;
    BOOL _isLayoutSubView;
}
@property (nonatomic, strong) CAShapeLayer* circleLayer;
@property (nonatomic, strong) CAShapeLayer* tickLayer;
@property (nonatomic, copy) CompleteBlock completeBlock;
@end

@implementation PaySuccessView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createSelf];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSelf];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)dealloc{
    NSLog(@"PaySuccessView dealloc");
}

-(void)createSelf{
    _isLayoutSubView = NO;
    _needStartAni = NO;
    _circleColor = [UIColor greenColor].CGColor;
    _tickColor = [UIColor greenColor].CGColor;
    _circleWidth = 5;
    _tickWidth = 5;
    _aniDuration = 2;
    
    self.circleLayer = [[CAShapeLayer alloc] init];
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = self.circleColor;
    _circleLayer.lineWidth = self.circleWidth;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 0;
    
    self.tickLayer = [[CAShapeLayer alloc] init];
    _tickLayer.fillColor = [UIColor clearColor].CGColor;
    _tickLayer.strokeColor = self.tickColor;
    _tickLayer.lineWidth = self.tickWidth;
    _tickLayer.lineCap = kCALineCapSquare;
    _tickLayer.strokeStart = 0;
    _tickLayer.strokeEnd = 0;
        
    [self.layer addSublayer:_circleLayer];
    [self.layer addSublayer:_tickLayer];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    _isLayoutSubView = YES;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2 - self.circleWidth/2;
    _circleLayer.path = [[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES] CGPath];
    UIBezierPath* tickPath = [[UIBezierPath alloc] init];
    [tickPath moveToPoint:CGPointMake(center.x-radius*0.8f, center.y-radius*0.2f)];
    [tickPath addLineToPoint:CGPointMake(center.x-radius*0.2f, center.y+radius*0.5f)];
    [tickPath addLineToPoint:CGPointMake(center.x+radius*0.7f, center.y-radius*0.50f)];
    _tickLayer.path = tickPath.CGPath;
    
    if(_needStartAni){
        [self startAniWithComplete:self.completeBlock];
        _needStartAni = NO;
    }
}

-(void)startAniWithComplete:(CompleteBlock)block{
    self.completeBlock = block;
    
    if(!_isLayoutSubView){
        _needStartAni = YES;
        return;
    }
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.removedOnCompletion = NO;
    circleAnimation.fillMode = kCAFillModeBoth;
    [circleAnimation setFromValue:[NSNumber numberWithFloat:0.f]];
    [circleAnimation setToValue:[NSNumber numberWithFloat:1.f]];
    [circleAnimation setDuration:self.aniDuration/2.f];
    [circleAnimation setBeginTime:0.f];

    CABasicAnimation *tickAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tickAnimation.removedOnCompletion = NO;
    tickAnimation.fillMode = kCAFillModeBoth;
    //animation的delegate是strong的，如果设置self会导致循环引用，因为将removedOnCompletion设置为NO了。
    tickAnimation.delegate = [[ProxyAnimationDelegate alloc] initWithDelegate:self];
    [tickAnimation setFromValue:[NSNumber numberWithFloat:0.f]];
    [tickAnimation setToValue:[NSNumber numberWithFloat:1.f]];
    [tickAnimation setDuration:self.aniDuration/2.f];
    [tickAnimation setBeginTime:CACurrentMediaTime()+self.aniDuration/2.f];

    [_circleLayer addAnimation:circleAnimation forKey:@"circleAnimation"];
    [_tickLayer addAnimation:tickAnimation forKey:@"tickAnimation"];
}

-(void)setTickColor:(CGColorRef)tickColor{
    _tickColor = tickColor;
    _tickLayer.strokeColor = _tickColor;
}

-(void)setCircleColor:(CGColorRef)circleColor{
    _circleColor = circleColor;
    _circleLayer.strokeColor = _circleColor;
}

-(void)setTickWidth:(CGFloat)tickWidth{
    _tickWidth = tickWidth;
    _tickLayer.lineWidth = _tickWidth;
}

-(void)setCircleWidth:(CGFloat)circleWidth{
    _circleWidth = circleWidth;
    _circleLayer.lineWidth = _circleWidth;
    [self setNeedsLayout];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.completeBlock) {
        self.completeBlock();
        self.completeBlock = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




