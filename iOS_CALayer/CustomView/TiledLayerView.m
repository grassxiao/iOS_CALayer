//
//  TileLayerView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "TiledLayerView.h"

typedef void(^DrawLayerBlock)(CALayer* layer, CGContextRef ctx);

@interface ProxyDelegate : NSObject<CALayerDelegate>
@property (nonatomic,copy) DrawLayerBlock drawLayerBlock;
@end

@implementation ProxyDelegate


-(instancetype)initWithBlock:(DrawLayerBlock)block{
    self = [super init];
    self.drawLayerBlock = block;
    return self;
}

-(void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    if(self.drawLayerBlock){
        self.drawLayerBlock(layer, ctx);
    }
}

@end


@interface TiledLayerView()
@property (nonatomic) CGImageRef tiledImage;
@property (nonatomic,strong) CATiledLayer* tiledLayer;
@property (nonatomic,strong) CAScrollLayer* scrollLayer;
@property (nonatomic,strong) ProxyDelegate* proxyDelegate;
@end

@implementation TiledLayerView

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
    
    self.tiledImage = [UIImage imageNamed:@"snow"].CGImage;

    self.scrollLayer = [CAScrollLayer layer];
    self.scrollLayer.frame = CGRectMake(0, 0, 3000, 3000);

    UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:gesture];
    
    self.tiledLayer = [CATiledLayer layer];
    self.tiledLayer.frame = self.scrollLayer.bounds;
    self.tiledLayer.tileSize = CGSizeMake(100, 100);
    
    __weak typeof(self)weakSelf = self;
    self.proxyDelegate = [[ProxyDelegate alloc] initWithBlock:^(CALayer *layer, CGContextRef ctx) {
        CGRect rect = CGContextGetClipBoundingBox(ctx);
        CGContextDrawImage(ctx, rect, weakSelf.tiledImage);
    }];
    //uiview已经是根layer的delegate，如果设置为子layer的delegate，可能造成不预期的问题。
    self.tiledLayer.delegate = self.proxyDelegate;
    [self.scrollLayer addSublayer:self.tiledLayer];
    
    [self.layer addSublayer:self.scrollLayer];
}

-(void)pan:(UIPanGestureRecognizer*)gesture{
    CGPoint translation = [gesture translationInView:self];
    CGPoint origin = self.scrollLayer.bounds.origin;
    origin = CGPointMake(origin.x-translation.x, origin.y-translation.y);
    origin.x = MIN(3000-self.bounds.size.width, origin.x);
    origin.y = MIN(3000-self.bounds.size.height, origin.y);
    origin.x = MAX(0, origin.x);
    origin.y = MAX(0, origin.y);
    [self.scrollLayer scrollToPoint:origin];
    [gesture setTranslation:CGPointZero inView:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
