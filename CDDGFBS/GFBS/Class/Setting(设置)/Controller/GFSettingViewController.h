//
//  GFSettingViewController.h
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "CuisineTableViewController.h"

@interface GFSettingViewController : UITableViewController <CuisineChildViewControllerDelegate, GIDSignInUIDelegate>

@end
