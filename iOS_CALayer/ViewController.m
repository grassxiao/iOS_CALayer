//
//  ViewController.m
//  iOS_CALayer
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 grass. All rights reserved.
//

#import "ViewController.h"
#import "PaySuccessView.h"
#import "InstrumentProgressView.h"
#import "WaveView.h"
#import "CircleWaitingView.h"

@interface ViewController ()
@property(nonatomic,strong) UIView* customView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.customViewClass){
        self.customViewClass = [PaySuccessView class];
    }
    
    self.customView = [[self.customViewClass alloc] initWithFrame:self.view.bounds];
    self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.customView];
    [self showTime];
    
}

-(void)dealloc{
    NSLog(@"ViewController");
}

-(void)showTime{
    if([self.customView isMemberOfClass:[PaySuccessView class]]){
        PaySuccessView* view = (PaySuccessView*)self.customView;
        [view startAniWithComplete:^{
            
        }];
    }
    else if([self.customView isMemberOfClass:[InstrumentProgressView class]]){
        InstrumentProgressView* view = (InstrumentProgressView*)self.customView;
        [view setStartDegrees:135 andEndDegrees:45];
        [view setProgress:0.9f withAni:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
