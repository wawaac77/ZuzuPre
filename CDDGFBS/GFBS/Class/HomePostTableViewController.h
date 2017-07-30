//
//  HomePostTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZContentModel.h"

@interface HomePostTableViewController : UITableViewController

-(MyPublishContentType)type;
-(NSString *)restaurantID;
//@property (nonatomic, copy) NSString *restaurantID;

@end
