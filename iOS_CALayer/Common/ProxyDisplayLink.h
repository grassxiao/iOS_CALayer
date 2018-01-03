//
//  ProxyDisplayLink.h
//  iOS_CALayer
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 grass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^DisplayBlock)(void);

@interface ProxyDisplayLink : NSObject
+(CADisplayLink*)proxyDisplayLink:(DisplayBlock)block;
@end
