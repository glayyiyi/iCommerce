//
//  VideoOfferWallViewController.m
//  DMOfferWallSample
//
//  Created by wangxijin on 13-12-4.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import "VideoOfferWallViewController.h"
#import "DMDemoConstants.h"

@interface VideoOfferWallViewController ()

@end

@implementation VideoOfferWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _videoOfferController = [[DMVideoViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:AGENT_ID];
        _videoOfferController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        
        self.presentOWButton.layer.borderColor = [[UIColor blackColor] CGColor];
        self.presentOWButton.layer.borderWidth = 1;
    }
    [_videoOfferController presentVideoAdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.presentOWButton = nil;
    _videoOfferController.delegate = nil;
    [_videoOfferController release];
    _videoOfferController = nil;
    [super dealloc];
}

#pragma mark - public

- (IBAction)presentVideoView:(id)sender {
    [_videoOfferController presentVideoAdView];
}

#pragma mark - DMVideoControllerDelegate
// 开始加载视频广告。
// Offer Video starts to fetch video.
- (void)offerVideoDidStartLoad {
    NSLog(@"offerVideoDidStartLoad");
}
// 积分视频广告加载完成。
// Fetching Offer Video successfully.
- (void)offerVideoDidFinishLoad {
    NSLog(@"offerVideoDidFinishLoad");
}
// 积分视频广告加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
// Failed to load Offer Video.
- (void)offerVideoDidFailLoadWithError:(NSError *)error {
    NSLog(@"offerVideoDidFailLoadWithError:%@",error);
}
// 积分视频广告页面被关闭。
// Offer Video closed.
- (void)offerVideoDidClosed {
    NSLog(@"offerVideoDidClosed");
}

@end
