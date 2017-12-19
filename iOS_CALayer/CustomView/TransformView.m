//
//  TransformView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "TransformView.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 255)

@interface TransformView()
@property (nonatomic, strong) CATransformLayer* transformLayer;
@end

@implementation TransformView


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
    self.transformLayer = [CATransformLayer layer];
    self.transformLayer.bounds = CGRectMake(0, 0, 100, 100);
    self.transformLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //前
    CATransform3D trans = CATransform3DMakeTranslation(0, 0, 50);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];

    //后
    trans = CATransform3DMakeTranslation(0, 0, -50);
    trans = CATransform3DRotate(trans, M_PI, 0, 1, 0);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];
    
    //左
    trans = CATransform3DMakeTranslation( -50, 0, 0);
    trans = CATransform3DRotate(trans,M_PI_2, 0, 1, 0);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];

    //右
    trans = CATransform3DMakeTranslation(50, 0, 0);
    trans = CATransform3DRotate(trans,-M_PI_2, 0, 1, 0);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];

    //上
    trans = CATransform3DMakeTranslation(0, 50, 0);
    trans = CATransform3DRotate(trans, -M_PI_2, 1, 0, 0);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];

    //下
    trans = CATransform3DMakeTranslation(0, -50, 0);
    trans = CATransform3DRotate(trans, M_PI_2, 1, 0, 0);
    [self.transformLayer addSublayer:[self createFaceWithTransform:trans]];

    [self.layer addSublayer:self.transformLayer];
    
    UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:gesture];
}

-(CALayer*)createFaceWithTransform:(CATransform3D)trans{
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = randomColor.CGColor;
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.transform = trans;
    return layer;
}

-(void)pan:(UIPanGestureRecognizer*)gesture{
    CGPoint point = [gesture translationInView:self];
    [gesture setTranslation:CGPointZero inView:self];
    
    CATransform3D orgin = self.transformLayer.transform;
    CATransform3D rotateX = CATransform3DMakeRotation(-point.y * M_PI/100, 1, 0, 0);
    CATransform3D rotateY = CATransform3DMakeRotation(point.x * M_PI/100, 0, 1, 0);
    CATransform3D trans = CATransform3DConcat(orgin, rotateX);
    trans = CATransform3DConcat(trans, rotateY);
    
    self.transformLayer.transform = trans;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    self.transformLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
