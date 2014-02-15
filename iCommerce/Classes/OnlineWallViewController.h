//
//  OnlineWallViewController.h
//  DomobOfferWallSDK
//
//  Created by Johnny on 12-11-29.
//  Copyright (c) 2012年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOfferWallViewController.h"

@interface OnlineWallViewController : UIViewController<DMOfferWallDelegate> {
    
    DMOfferWallViewController *_offerWallController;
}
@property (nonatomic,retain) IBOutlet UIButton *presentOWButton;

- (IBAction)presentOfferWall:(id)sender;

@end
