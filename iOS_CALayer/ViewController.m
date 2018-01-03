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
#import "HeadlineWaitingView.h"

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
    else if([self.customView isMemberOfClass:[HeadlineWaitingView class]]){
        HeadlineWaitingView* view = (HeadlineWaitingView*)self.customView;
        [self test:view];
    }
}

-(void)test:(HeadlineWaitingView*)view{
    CGFloat progress = view.progress + 0.03;
    if(progress >= 1){
        view.progress = 1;
        [view startAni];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view stopAni];
        });
    }
    else{
        view.progress = progress;
        [self performSelector:@selector(test:) withObject:view afterDelay:0.1];
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
