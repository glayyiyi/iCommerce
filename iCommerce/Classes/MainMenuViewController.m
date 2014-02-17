//
//  MainMenuViewController.m
//  DomobOfferWallSDK
//
//  Created by Johnny on 12-9-20.
//  Copyright (c) 2012年 domob. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OnlineWallViewController.h"
#import "VideoOfferWallViewController.h"
#import "OWInterstitialViewController.h"
#import "OfferManageViewController.h"
#import "Countly.h"
#import "DMDemoConstants.h"
#import <Cordova/CDVViewController.h>



static NSString *kCellIdentifier = @"MyIdentifier";

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _menu.delegate = self;
    _menu.dataSource = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.menu = nil;
}

- (void)dealloc {
    
    [_menu release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"应用列表";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"视频积分墙";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"插屏积分墙";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"积分管理";
    }
    else {
        cell.textLabel.text = @"首页";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_menu deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    if (indexPath.row == 0) {
//        NSException *e = [NSException exceptionWithName:@"Null reference" reason:@"UIKit.framework.Exception" userInfo:nil];
//        @throw e;

         [[Countly sharedInstance] recordEvent:@"点击菜单" segmentation:@{@"类型" : @"列表积分墙",@"用户":AGENT_ID} count:1];
        controller = [[OnlineWallViewController alloc] initWithNibName:@"OnlineWallViewController" bundle:nil];
    }
    else if (indexPath.row == 1) {
         [[Countly sharedInstance] recordEvent:@"点击菜单" segmentation:@{@"类型" : @"视频积分墙",@"用户":AGENT_ID} count:1];
        controller = [[VideoOfferWallViewController alloc] initWithNibName:@"VideoOfferWallViewController" bundle:nil];
    }
    else if (indexPath.row == 2) {
        [[Countly sharedInstance] recordEvent:@"点击菜单" segmentation:@{@"类型" : @"插屏积分墙",@"用户":AGENT_ID} count:1];
        controller = [[OWInterstitialViewController alloc] initWithNibName:@"OWInterstitialViewController" bundle:nil];
    }
    else if (indexPath.row == 3) {
         [[Countly sharedInstance] recordEvent:@"点击菜单" segmentation:@{@"类型" : @"积分管理",@"用户":AGENT_ID} count:1];
        
        controller = [[OfferManageViewController alloc] initWithNibName:@"OfferManageViewController" bundle:nil];
    }

    if (controller) {
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        //[self.view removeFromSuperview];
        
         //[self.view addSubview:controller.view];
       
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case 0:
            title = @"";
            break;
        default:
            break;
    }
    
    return title;
}
@end
