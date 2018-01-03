//
//  ProxyDisplayLink.m
//  iOS_CALayer
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 grass. All rights reserved.
//

#import "ProxyDisplayLink.h"

@interface ProxyDisplayLink ()
@property (nonatomic,copy) DisplayBlock displayBlock;
@end

@implementation ProxyDisplayLink

+(CADisplayLink*)proxyDisplayLink:(DisplayBlock)block{
    ProxyDisplayLink* proxy = [[ProxyDisplayLink alloc] initWithBlock:block];
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(update)];
    return displayLink;
}

-(void)update{
    if(self.displayBlock){
        self.displayBlock();
    }
}

-(instancetype)initWithBlock:(DisplayBlock)block{
    self = [super init];
    self.displayBlock = block;
    return self;
}

-(void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end


