//
//  OWInterstitialViewController.m
//  DomobOfferWallSDK
//
//  Created by Johnny on 13-3-28.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import "OWInterstitialViewController.h"
#import "DMDemoConstants.h"
#import "Toast+UIView.h"
#import "DMAppDelegate.h"
#import "DMOfferWallManager.h"

@interface OWInterstitialViewController ()

@end

@implementation OWInterstitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:AGENT_ID];
        _offerWallController.delegate = self;
        // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
        _offerWallController.disableStoreKit = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.presentInlineBtn.hidden = YES;
    self.presentBtn.hidden = NO;
    self.indicator.hidden = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        
        self.presentBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        self.presentBtn.layer.borderWidth = 1;
        
        self.presentInlineBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        self.presentInlineBtn.layer.borderWidth = 1;
    }
    //[self loadOWInterstitital:nil];
    
    
    
}
    
    - (void)viewWillAppear:(BOOL)animated
    {
         //[self presentOWInterstitital:nil];
        
        [super viewWillAppear:animated];
    }
    
   

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 注意：调用loadOfferWallInterstitial和调用presentOfferWallInterstitial的次数需要一一对应，即：
 * load积分墙插屏后，必须调用present展现积分墙后，才能请求下一个积分墙插屏广告；
 * 调用present展现积分墙插屏后，必须重新load插屏积分墙，才能展现下一个积分墙插屏。
 */

//首先请求插屏积分墙广告，调用loadOfferWallInterstitial方法。会同时请求积分墙和插屏广告
- (IBAction)loadOWInterstitital:(id)sender {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootViewController) {
        NSLog(@"Application root controller.");
        _offerWallController.rootViewController = rootViewController;
    }
    [_offerWallController loadOfferWallInterstitial];
}
//加载插屏积分墙后，在合适的位置展现插屏积分墙，调用presentOfferWallInterstitial方法
- (IBAction)presentOWInterstitital:(id)sender {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootViewController) {
        NSLog(@"Application root controller.");
        _offerWallController.rootViewController = rootViewController;
    }
    //首先需要判断插屏积分墙广告是否已经加载成功了。
    if ([_offerWallController isOfferWallInterstitialReady]) {
        [_offerWallController presentOfferWallInterstitial];
    }
}

#pragma mark - DMOfferWallDelegate <NSObject>
// 积分墙开始加载数据。
// Offer wall starts to work.
- (void)offerWallDidStartLoad {
    NSLog(@"offerWallDidStartLoad");
}

// 积分墙加载完成。此方法实现中可进行积分墙入口Button显示等操作。
- (void)offerWallDidFinishLoad {
    NSLog(@"offerWallDidFinishLoad");
    [self.view makeToast:@"Offer Wall List Loading Finished."];
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。建议在此隐藏积分墙入口Button。
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    NSLog(@"offerWallDidFailLoadWithError:%@", error);
    [self.view makeToast:@"Offer Wall List Loading Failed."];
}

#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishCheckPoint");
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailCheckPointWithError:%@", error);
}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishConsumePoint");
    switch (statusCode) {
        case DMOfferWallConsumeStatusCodeSuccess:
            [self.view makeToast:@"消费成功！"];
            break;
        case DMOfferWallConsumeStatusCodeInsufficient:
            [self.view makeToast:@"消费失败，余额不足！"];
            break;
        default:
            break;
    }
}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailConsumePointWithError:%@", error);
}

// 关闭积分墙页面。
// Offer wall closed.
- (void)offerWallDidClosed {
    NSLog(@"offerWallDidClosed");
}

#pragma mark OfferWall Interstitial
// 当积分墙插屏广告被成功加载后，回调该方法
- (void)dmOfferWallInterstitialSuccessToLoadAd:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialSuccessToLoadAd");
    self.presentInlineBtn.hidden = NO;
    [self.view makeToast:@"Offer Wall List Loading Finished."];
}

// 当积分墙插屏广告加载失败后，回调该方法
- (void)dmOfferWallInterstitialFailToLoadAd:(DMOfferWallViewController *)dmOWInterstitial withError:(NSError *)err {
    NSLog(@"dmOfferWallInterstitialFailToLoadAd:%@", err);
    self.presentInlineBtn.hidden = YES;
}

// 当积分墙插屏广告要被呈现出来前，回调该方法
- (void)dmOfferWallInterstitialWillPresentScreen:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialWillPresentScreen");
}

// 当积分墙插屏广告被关闭后，回调该方法
- (void)dmOfferWallInterstitialDidDismissScreen:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialDidDismissScreen");
    self.presentInlineBtn.hidden = YES;
}
@end
