//
//  AllHomeTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 12/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AllHomeTableViewController.h"

@interface AllHomeTableViewController ()

@end

@implementation AllHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(GFTopicType)type
{
    return GFTopicTypeAll;
}

@end
