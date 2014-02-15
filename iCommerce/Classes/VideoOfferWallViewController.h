//
//  VideoOfferWallViewController.h
//  DMOfferWallSample
//
//  Created by wangxijin on 13-12-4.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMVideoViewController.h"

@interface VideoOfferWallViewController : UIViewController<DMVideoControllerDelegate> {
    DMVideoViewController *_videoOfferController;
}

@property (nonatomic,retain) IBOutlet UIButton *presentOWButton;

- (IBAction)presentVideoView:(id)sender;

@end
