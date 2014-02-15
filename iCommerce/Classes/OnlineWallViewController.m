//
//  OnlineWallViewController.m
//  DomobOfferWallSDK
//
//  Created by Johnny on 12-11-29.
//  Copyright (c) 2012年 domob. All rights reserved.
//

#import "OnlineWallViewController.h"
#import "DMDemoConstants.h"
#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>


@interface OnlineWallViewController ()

@end

@implementation OnlineWallViewController

@synthesize presentOWButton = _presentOWButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:AGENT_ID];
        // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
        _offerWallController.disableStoreKit = NO;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _offerWallController.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        
        self.presentOWButton.layer.borderColor = [[UIColor blackColor] CGColor];
        self.presentOWButton.layer.borderWidth = 1;
    }
    [_offerWallController presentOfferWall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.presentOWButton = nil;
    
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - public

- (IBAction)presentOfferWall:(id)sender {
    [_offerWallController presentOfferWall];
}

#pragma mark - DMOfferWallDelegate <NSObject>
// 积分墙开始加载数据。
// Offer wall starts to work.
- (void)offerWallDidStartLoad {
    NSLog(@"offerWallDidStartLoad");
}

// 积分墙加载完成。此方法实现中可进行积分墙入口Button显示等操作。
// Load offer wall successfully. You can set your IBOutlet.hidden to NO in this callback.
// This IBOutlet is the one which response to present OfferWall.
- (void)offerWallDidFinishLoad {
    NSLog(@"offerWallDidFinishLoad");
    [self.view makeToast:@"Offer Wall Loading Finished."];
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。建议在此隐藏积分墙入口Button。
// Failed to load offer wall. You should set THE IBOutlet.hidden to YES in this callback.
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    NSLog(@"offerWallDidFailLoadWithError:%@", error);
    [self.view makeToast:@"Offer Wall Loading Failed."];
}

-(void)offerWallDidClosed{
    NSLog(@"offer Wall closed!");
    [self.view makeToast:@"Offer Wall closed."];
}

@end
