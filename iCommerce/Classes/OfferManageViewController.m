//
//  OfferManageViewController.m
//  DMOfferWallSample
//
//  Created by wangxijin on 13-12-4.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import "OfferManageViewController.h"
#import "DMDemoConstants.h"
#import "AppDelegate.h"

@interface OfferManageViewController ()

@end

@implementation OfferManageViewController
@synthesize pointLabel = _pointLabel;
@synthesize consumeLabel = _consumeLabel;
@synthesize statusLabel = _statusLabel;
@synthesize pointsInput = _pointsInput;


@synthesize comsumeOWButton;
@synthesize checkPointOWButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:PUBLISHER_ID userId:myDelegate.userId];
        _offerWallManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pointsInput.delegate = self;
    _pointsInput.keyboardType = UIKeyboardTypeDecimalPad;
    _statusLabel.text = @"空闲";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        
        self.comsumeOWButton.layer.borderColor = [[UIColor blackColor] CGColor];
        self.comsumeOWButton.layer.borderWidth = 1;
        
        self.checkPointOWButton.layer.borderColor = [[UIColor blackColor] CGColor];
        self.checkPointOWButton.layer.borderWidth = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.pointLabel = nil;
    self.consumeLabel = nil;
    self.statusLabel = nil;
    self.pointsInput = nil;
    
    _offerWallManager.delegate = nil;
    [_offerWallManager release];
    _offerWallManager = nil;
    
    [super dealloc];
}

#pragma mark - public 
- (IBAction)consume:(id)sender {
    [_offerWallManager requestOnlineConsumeWithPoint:[_pointsInput.text integerValue]];
    _statusLabel.text = @"请求消费中。。。";
}

- (void)checkPoint:(id)sender {
    [_offerWallManager requestOnlinePointCheck];
    _statusLabel.text = @"请求积分检查中。。。";
}

- (IBAction)dismissKeyBoard:(id)sender {
    [_pointsInput resignFirstResponder];
}

#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishCheckPoint");
    _pointLabel.text = [NSString stringWithFormat:@"%d", totalPoint];
    _consumeLabel.text = [NSString stringWithFormat:@"%d", consumed];
    _statusLabel.text = @"空闲";
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailCheckPointWithError:%@", error);
    _statusLabel.text = @"空闲";
}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishConsumePoint");
    switch (statusCode) {
        case DMOfferWallConsumeStatusCodeSuccess:
            [self.view makeToast:@"消费成功！"];
            break;
        case DMOfferWallConsumeStatusCodeInsufficient:
            [self.view makeToast:@"消费失败，余额不足！"];
            break;
        default:
            break;
    }
    
    _pointLabel.text = [NSString stringWithFormat:@"%d", totalPoint];
    _consumeLabel.text = [NSString stringWithFormat:@"%d", consumed];
    _statusLabel.text = @"空闲";
}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailConsumePointWithError:%@", error);
    _statusLabel.text = @"空闲";
}

#pragma mark - TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = 44 + 216 - (460 - moveUpValue - 5);
    }
    else
    {
        animatedDistance = 44 + 162 - (320 - moveUpValue - 5);
    }
    
    if(animatedDistance>0)
    {
        int movementDistance = animatedDistance;
        float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}
@end
