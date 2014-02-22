/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVNotification.h"
#import <Cordova/NSDictionary+Extensions.h>
#import <Cordova/NSArray+Comparisons.h>

#import "OnlineWallViewController.h"
#import "VideoOfferWallViewController.h"
#import "OWInterstitialViewController.h"
#import "OfferManageViewController.h"

#import "AppDelegate.h"
#import "Countly.h"
#import "DMDemoConstants.h"

#define DIALOG_TYPE_ALERT @"alert"
#define DIALOG_TYPE_PROMPT @"prompt"
#define DIALOG_TYPE_LOGIN @"login"
#define DIALOG_TYPE_INVOKE @"invoke"

static void soundCompletionCallback(SystemSoundID ssid, void* data);

@implementation CDVNotification

/*
 * showDialogWithMessage - Common method to instantiate the alert view for alert, confirm, and prompt notifications.
 * Parameters:
 *  message       The alert view message.
 *  title         The alert view title.
 *  buttons       The array of customized strings for the buttons.
 *  defaultText   The input text for the textbox (if textbox exists).
 *  callbackId    The commmand callback id.
 *  dialogType    The type of alert view [alert | prompt].
 */
- (void)showDialogWithMessage:(NSString*)message title:(NSString*)title buttons:(NSArray*)buttons defaultText:(NSString*)defaultText callbackId:(NSString*)callbackId dialogType:(NSString*)dialogType
{
    CDVAlertView* alertView = [[CDVAlertView alloc]
        initWithTitle:title
                  message:message
                 delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:nil];

    alertView.callbackId = callbackId;

    int count = [buttons count];

    for (int n = 0; n < count; n++) {
        [alertView addButtonWithTitle:[buttons objectAtIndex:n]];
    }

    if ([dialogType isEqualToString:DIALOG_TYPE_PROMPT]) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField* textField = [alertView textFieldAtIndex:0];
        textField.text = defaultText;
    }
    if ([dialogType isEqualToString:DIALOG_TYPE_LOGIN]) {
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField* textField = [alertView textFieldAtIndex:0];
        
        textField.text = defaultText;
    }
    if ([dialogType isEqualToString:DIALOG_TYPE_INVOKE]) {
        
        return;
    }

    [alertView show];
}

- (void)alert:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSString* buttons = [command argumentAtIndex:2];

    [self showDialogWithMessage:message title:title buttons:@[buttons] defaultText:nil callbackId:callbackId dialogType:DIALOG_TYPE_ALERT];
}

- (void)confirm:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSArray* buttons = [command argumentAtIndex:2];

    [self showDialogWithMessage:message title:title buttons:buttons defaultText:nil callbackId:callbackId dialogType:DIALOG_TYPE_ALERT];
}

- (void)prompt:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSArray* buttons = [command argumentAtIndex:2];
    NSString* defaultText = [command argumentAtIndex:3];

    [self showDialogWithMessage:message title:title buttons:buttons defaultText:defaultText callbackId:callbackId dialogType:DIALOG_TYPE_PROMPT];
}

- (void)login:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSArray* buttons = [command argumentAtIndex:2];
    NSString* defaultText = [command argumentAtIndex:3];
    [[Countly sharedInstance] recordEvent:title segmentation:@{@"type" : message,@"user":defaultText} count:1];
    
    if (message&&buttons&&[buttons count]==0){
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.userId = defaultText;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if([message isEqual:@"OnlineWallViewController"]){
            OnlineWallViewController *controller = [[OnlineWallViewController alloc] initWithNibName:message bundle:nil];
            controller.view.frame =screenBounds;
            [self.webView addSubview:controller.view];
        }
        if([message isEqual:@"OfferManageViewController"]){
            OfferManageViewController *controller = [[OfferManageViewController alloc] initWithNibName:message bundle:nil];
            myDelegate.viewController.navigationController.navigationBarHidden = NO;
            [myDelegate.viewController.navigationController pushViewController:controller animated:true];
            [controller release];
            //controller.view.frame =screenBounds;
            //[self.webView addSubview:controller.view];
        }
        if([message isEqual:@"OWInterstitialViewController"]){
            OWInterstitialViewController *controller = [[OWInterstitialViewController alloc] initWithNibName:message bundle:nil];
            controller.view.frame =screenBounds;
            [self.webView addSubview:controller.view];
        }
        if([message isEqual:@"VideoOfferWallViewController"]){
            VideoOfferWallViewController *controller = [[VideoOfferWallViewController alloc] initWithNibName:message bundle:nil];
            controller.view.frame =screenBounds;
            [self.webView addSubview:controller.view];
        }
    }
    
    
    if(buttons&&[buttons count]>0)
        [self showDialogWithMessage:message title:title buttons:buttons defaultText:defaultText callbackId:callbackId dialogType:DIALOG_TYPE_LOGIN];
}

- (void)invoke:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSArray* buttons = [command argumentAtIndex:2];
    NSString* defaultText = [command argumentAtIndex:3];
    
    [[Countly sharedInstance] recordEvent:title segmentation:@{@"type" : message,@"command":title,@"user":defaultText} count:1];
    
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.userId = defaultText;
    myDelegate.callbackId = callbackId;
     _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:PUBLISHER_ID userId:myDelegate.userId];
     _videoOfferController = [[DMVideoViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:myDelegate.userId];
     _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:myDelegate.userId];
    
    _offerWallManager.delegate = self;
    _videoOfferController.delegate = self;
    _offerWallController.delegate=self;
    
    // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
    _offerWallController.disableStoreKit = NO;

    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if([message isEqual:@"btn_wall_get"]){
            
       
            [_offerWallController presentOfferWall];
            
        }else if([message isEqual:@"btn_wall_check"]){
            
            
            [_offerWallManager requestOnlinePointCheck];

          
        }else if([message isEqual:@"btn_wall_use"]){
        
            [_offerWallManager requestOnlineConsumeWithPoint:[defaultText integerValue]];
        
        
        }
        else if([message isEqual:@"btn_wall_inside"]){
            //OWInterstitialViewController *controller = [[OWInterstitialViewController alloc] initWithNibName:@"OWInterstitialViewController" bundle:nil];
            
            //[self.webView addSubview:controller.view];
            
            [_offerWallController loadOfferWallInterstitial];
            //[_offerWallController presentOfferWallInterstitial];
        }
        else if([message isEqual:@"btn_wall_video"]){
            
            [_videoOfferController presentVideoAdView];
        }
    }


#pragma mark OfferWall Interstitial
// 当积分墙插屏广告被成功加载后，回调该方法
- (void)dmOfferWallInterstitialSuccessToLoadAd:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialSuccessToLoadAd");
    [_offerWallController presentOfferWallInterstitial];
}

// 当积分墙插屏广告加载失败后，回调该方法
- (void)dmOfferWallInterstitialFailToLoadAd:(DMOfferWallViewController *)dmOWInterstitial withError:(NSError *)err {
    NSLog(@"dmOfferWallInterstitialFailToLoadAd:%@", err);
   }

// 当积分墙插屏广告要被呈现出来前，回调该方法
- (void)dmOfferWallInterstitialWillPresentScreen:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialWillPresentScreen");
}

// 当积分墙插屏广告被关闭后，回调该方法
- (void)dmOfferWallInterstitialDidDismissScreen:(DMOfferWallViewController *)dmOWInterstitial {
    NSLog(@"dmOfferWallInterstitialDidDismissScreen");
    
}


#pragma mark Point Check Callbacks
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishCheckPoint");

    NSString* value0 = [NSString stringWithFormat:@"%d", totalPoint];
    NSString* value1 = [NSString stringWithFormat:@"%d", consumed];
    NSDictionary* info = @{
                           @"buttonIndex":value1,
                           @"input1":(value0 ? value0 : [NSNull null])
                           };
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    [self.commandDelegate sendPluginResult:result callbackId:myDelegate.callbackId];
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailCheckPointWithError:%@", error);

}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
    NSLog(@"offerWallDidFinishConsumePoint");
    CDVPluginResult* result = nil;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString* value0 = [NSString stringWithFormat:@"%d", totalPoint];
    NSString* value1 = [NSString stringWithFormat:@"%d", consumed];
    NSDictionary* info = @{
                           @"buttonIndex":value1,
                           @"input1":(value0 ? value0 : [NSNull null])
                           
                           };

    switch (statusCode) {
        case DMOfferWallConsumeStatusCodeSuccess:
            //消费成功
             result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
            break;
        case DMOfferWallConsumeStatusCodeInsufficient:
            //余额不足
             result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:nil];
            break;
        default:
            break;
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:myDelegate.callbackId];

}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    NSLog(@"offerWallDidFailConsumePointWithError:%@", error);
   
}

#pragma mark - DMOfferWallDelegate <NSObject>
// 积分墙开始加载数据。
// Offer wall starts to work.
- (void)offerWallDidStartLoad {
    NSLog(@"offerWallDidStartLoad");
}

// 积分墙加载完成。此方法实现中可进行积分墙入口Button显示等操作。
// Load offer wall successfully. You can set your IBOutlet.hidden to NO in this callback.
// This IBOutlet is the one which response to present OfferWall.
- (void)offerWallDidFinishLoad {
    NSLog(@"offerWallDidFinishLoad");
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。建议在此隐藏积分墙入口Button。
// Failed to load offer wall. You should set THE IBOutlet.hidden to YES in this callback.
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    NSLog(@"offerWallDidFailLoadWithError:%@", error);
    
}

-(void)offerWallDidClosed{
    NSLog(@"offer Wall closed!");
   }

/**
  * Callback invoked when an alert dialog's buttons are clicked.
  */
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CDVAlertView* cdvAlertView = (CDVAlertView*)alertView;
    CDVPluginResult* result;

    // Determine what gets returned to JS based on the alert view type.
    if (alertView.alertViewStyle == UIAlertViewStyleDefault) {
        // For alert and confirm, return button index as int back to JS.
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:buttonIndex + 1];
    } else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput){
        // For prompt, return button index and input text back to JS.
        NSString* value0 = [[alertView textFieldAtIndex:0] text];
        NSDictionary* info = @{
            @"buttonIndex":@(buttonIndex + 1),
            @"input1":(value0 ? value0 : [NSNull null])
        };
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
    }else{
       
            // For prompt, return button index and input password back to JS.
            NSString* value0 = [[alertView textFieldAtIndex:0] text];
            NSString* value1 = [[alertView textFieldAtIndex:1] text];
            NSDictionary* info = @{
                                   @"buttonIndex":@(buttonIndex + 1),
                                   @"input1":(value0 ? value0 : [NSNull null]),
                                   @"input2":(value0 ? value1 : [NSNull null])
                                   };
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        
       
    }
    [self.commandDelegate sendPluginResult:result callbackId:cdvAlertView.callbackId];
}

static void playBeep(int count) {
    SystemSoundID completeSound;
    NSURL* audioPath = [[NSBundle mainBundle] URLForResource:@"CDVNotification.bundle/beep" withExtension:@"wav"];
    #if __has_feature(objc_arc)
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioPath, &completeSound);
    #else
        AudioServicesCreateSystemSoundID((CFURLRef)audioPath, &completeSound);
    #endif
    AudioServicesAddSystemSoundCompletion(completeSound, NULL, NULL, soundCompletionCallback, (void*)(count-1));
    AudioServicesPlaySystemSound(completeSound);
}

static void soundCompletionCallback(SystemSoundID  ssid, void* data) {
    int count = (int)data;
    AudioServicesRemoveSystemSoundCompletion (ssid);
    AudioServicesDisposeSystemSoundID(ssid);
    if (count > 0) {
        playBeep(count);
    }
}

- (void)beep:(CDVInvokedUrlCommand*)command
{
    NSNumber* count = [command.arguments objectAtIndex:0 withDefault:[NSNumber numberWithInt:1]];
    playBeep([count intValue]);
}


@end

@implementation CDVAlertView

@synthesize callbackId;

@end
