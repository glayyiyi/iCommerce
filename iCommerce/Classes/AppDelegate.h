//
//  AppDelegate.h
//  iCommerce
//
//  Created by Glay Guo on 14-2-12.
//  Copyright (c) 2014年 Glay Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSAgent.h"
#import "FirstViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FirstViewController *viewController;

@property BOOL isLogin;

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *callbackId;


@end
