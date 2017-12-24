//
//  CustomPropertyAniView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "CustomPropertyAniView.h"

@interface CustomLayer : CALayer
@property (nonatomic,assign) CGFloat aniValue;
@end

@implementation CustomLayer
//很重要，否则会自动合成属性，导致actionForKey不调用
@dynamic aniValue;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

+ (nullable id)defaultValueForKey:(NSString *)key{
    if ([@"aniValue" isEqualToString:key])
    {
        return @1.f;
    }
    return [super defaultValueForKey:key];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([@"aniValue" isEqualToString:key])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)key
{
    if ([key isEqualToString:@"aniValue"])
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"aniValue"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.fromValue = [[self presentationLayer] valueForKey:@"aniValue"];
        return anim;
    }
    return [super actionForKey:key];
}

- (void)display
{
    CGFloat ani = self.aniValue;
    if(self.presentationLayer){
        ani = self.presentationLayer.aniValue;
    }
    NSLog(@"display %f",ani);
    CATransform3D trans = CATransform3DMakeRotation(ani*2*M_PI, 0, 0, 1);
    trans = CATransform3DScale(trans, ani, ani, 1);
    self.transform = trans;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawInContext:ctx];
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}
@end


@interface CustomPropertyAniView()
@property (nonatomic,strong) CustomLayer* rectLayer;
@end

@implementation CustomPropertyAniView

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
    self.rectLayer = [CustomLayer layer];
    self.rectLayer.backgroundColor = [UIColor redColor].CGColor;
    self.rectLayer.frame = CGRectMake(100, 100, 100, 100);
    [self.layer addSublayer:self.rectLayer];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2), dispatch_get_main_queue(), ^{
        [CATransaction setAnimationDuration:2];
        NSLog(@"aniValue start %f",weakSelf.rectLayer.aniValue);
        weakSelf.rectLayer.aniValue = 0;
        NSLog(@"aniValue end %f",weakSelf.rectLayer.aniValue);
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
