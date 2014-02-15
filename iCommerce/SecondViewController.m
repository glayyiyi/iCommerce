//
//  SecondViewController.m
//  iCommerce
//
//  Created by Glay Guo on 14-2-12.
//  Copyright (c) 2014年 Glay Guo. All rights reserved.
//

#import "SecondViewController.h"
#import "MainMenuViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    
    
     MainMenuViewController *menuController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuController];
  
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //viewController.view.frame = CGRectMake(0, 0, 320, 480);
    menuController.view.frame =screenBounds;

    
    [self.view addSubview:menuController.view];
    
    
    
    [super viewDidAppear:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
