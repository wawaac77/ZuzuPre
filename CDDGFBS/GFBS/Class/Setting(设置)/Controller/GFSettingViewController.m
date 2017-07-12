//
//  GFSettingViewController.m
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFSettingViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
static NSString*const ID = @"ID";
@interface GFSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
//@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
//@property (weak, nonatomic) NSString *priceRange;


@end

@implementation GFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    
    //计算整个应用程序的缓存数据 --- > 沙盒（Cache）
    //NSFileManager
    //attributesOfItemAtPathe:指定文件路径，获取文件属性
    //把所有文件尺寸加起来    //获取缓存尺寸字符串赋值给cell的textLabel
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    //[tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor darkGrayColor];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Cuisine";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            //if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            //}
            cell.textLabel.text = @"Price(HK$)";
            cell.detailTextLabel.text = @"0 - 200"; //initialize
            //add slider
            UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(120, 0, self.view.gf_width - 200, 44)];
            sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            sliderView.value = 200; // initialize
            sliderView.maximumValue = 2000;
            [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:sliderView];
            /*
            //add rangeLabel
            self.rangeLabel.frame = CGRectMake(360, 10, 100, 40);
            self.rangeLabel.backgroundColor = [UIColor redColor];
            [cell addSubview:self.rangeLabel];
             */
        } else {
            cell.textLabel.text = @"Location";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 1) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Allow Notification";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            //[switchView release];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Email Notification";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Sounds";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        } else {
            cell.textLabel.text = @"Show on Lock Screen";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
            cell.textLabel.text = [NSString stringWithFormat:@"Clear Buffer Memory（used %.2fMB）", size];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"About Zuzu";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Message Admin";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"Version 1.0";
        }
    }

    return cell;
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog(@"This switch is %@", switchControl.on ? @"ON" : @"OFF");
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    parentCell.detailTextLabel.text = [NSString stringWithFormat:@"0 - %@", priceRange];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    if (size != 0) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            [[SDImageCache sharedImageCache] clearDisk];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithStatus:@"Deleting buffer memory..."];
            NSLog(@"Delering buffer memory selected");
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    });
    
}


@end
