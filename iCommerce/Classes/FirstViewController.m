//
//  FirstViewController.m
//  iCommerce
//
//  Created by Glay Guo on 14-2-12.
//  Copyright (c) 2014年 Glay Guo. All rights reserved.
//

#import "FirstViewController.h"
#import <Cordova/CDVViewController.h>


@interface FirstViewController ()

@end

@implementation FirstViewController

CDVViewController* cdvViewController ;

- (void)viewDidLoad
{


    [super viewDidLoad];
     cdvViewController = [CDVViewController new];
     //viewController.startPage = @"http://www.appcn100.com/mobile";
    cdvViewController.wwwFolderName = @"www";
    cdvViewController.startPage = @"index.html";
    [UMSAgent checkUpdate];
    
        
	// Do any additional setup after loading the view, typically from a nib.


}

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //viewController.view.frame = CGRectMake(0, 0, 320, 480);
    cdvViewController.view.frame =screenBounds;
    
    [self.view addSubview:cdvViewController.view];
    [cdvViewController.webView reload];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([cdvViewController.webView isLoading])
        [cdvViewController.webView stopLoading];
    // [viewController.webView stringByEvaluatingJavaScriptFromString:@"destroy();"];
    [super viewWillDisappear:animated];
   
}

- (void)dealloc {
    
    //viewController.webView.delegate = nil;
    //viewController.webView = nil;
    //[viewController release];
    //viewController=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
