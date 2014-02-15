//
//  OWInterstitialViewController.h
//  DomobOfferWallSDK
//
//  Created by Johnny on 13-3-28.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOfferWallViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OWInterstitialViewController : UIViewController<DMOfferWallDelegate> {
    DMOfferWallViewController *_offerWallController;
}
@property (nonatomic, retain) IBOutlet UIButton *presentBtn;
@property (nonatomic, retain) IBOutlet UIButton *presentInlineBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)loadOWInterstitital:(id)sender;
- (IBAction)presentOWInterstitital:(id)sender;
@end
