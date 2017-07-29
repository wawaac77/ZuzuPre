//
//  RestaurantOverviewViewController.m
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantOverviewViewController.h"
#import "OverviewCell.h"

#import "UILabel+LabelHeightAndWidth.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

static NSString *const basicID = @"basicID";
static NSString *const highLabelID = @"highLabelID";

@interface RestaurantOverviewViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RestaurantOverviewViewController

@synthesize thisRestaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (void)setUpTable
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, GFTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OverviewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:basicID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:highLabelID];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 50.0f;
    }
    
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:basicID];
        if (cell == nil) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:basicID];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 20)];
            [cell.contentView addSubview:label];
        }
        cell.imageView = [UIImage imageNamed:@"ic_location"];
        cell.label
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:highLabelID];
        if (cell == nil) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:highLabelID];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            [cell.contentView addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 0)];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:label.font];
            label.gf_height = height;
            [cell.contentView addSubview:label];
            
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [cell.contentView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 0)];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        
        CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:label.font];
        
        
        
        
    }
    EventRestaurant *thisRestaurant = self.restaurants[indexPath.row];
    cell.restaurant = thisRestaurant;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetailVC = [[RestaurantDetailViewController alloc] init];
    //restaurantDetailVC.topic = self.tableView[indexPath.row];
    [self.navigationController pushViewController:restaurantDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
