//
//  MainMenuViewController.h
//  DomobOfferWallSDK
//
//  Created by Johnny on 12-9-20.
//  Copyright (c) 2012年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {

}

@property (nonatomic, retain) IBOutlet UITableView *menu;
@end
