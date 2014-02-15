//
//  OfferManageViewController.h
//  DMOfferWallSample
//
//  Created by wangxijin on 13-12-4.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOfferWallManager.h"

@interface OfferManageViewController : UIViewController<UITextFieldDelegate> {
    
    DMOfferWallManager *_offerWallManager;
}

@property (nonatomic,retain) IBOutlet UIButton *comsumeOWButton;
@property (nonatomic,retain) IBOutlet UIButton *checkPointOWButton;
@property (nonatomic,retain) IBOutlet UILabel *pointLabel;
@property (nonatomic,retain) IBOutlet UILabel *consumeLabel;
@property (nonatomic,retain) IBOutlet UILabel *statusLabel;
@property (nonatomic,retain) IBOutlet UITextField *pointsInput;

- (IBAction)consume:(id)sender;
- (IBAction)checkPoint:(id)sender;
- (IBAction)dismissKeyBoard:(id)sender;

@end
