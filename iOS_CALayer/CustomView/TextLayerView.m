//
//  TextLayerView.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "TextLayerView.h"

@interface TextLayerView()
@property (nonatomic, strong) CATextLayer* textLayer;
@end

@implementation TextLayerView

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
    self.textLayer = [CATextLayer layer];
    self.textLayer.foregroundColor = [UIColor blackColor].CGColor;  //字体颜色
    self.textLayer.font = (__bridge CFTypeRef)[UIFont systemFontOfSize:40].fontName;
    self.textLayer.fontSize = 40;
    self.textLayer.frame = self.bounds;
    self.textLayer.wrapped = YES;       //是否换行
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;
    self.textLayer.alignmentMode = kCAAlignmentCenter;      //对齐
    self.textLayer.truncationMode = kCATruncationEnd;       //截断方式
    self.textLayer.string = @"选择比努力更加重要！\n加油吧，骚年！";
    [self.layer addSublayer:self.textLayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
