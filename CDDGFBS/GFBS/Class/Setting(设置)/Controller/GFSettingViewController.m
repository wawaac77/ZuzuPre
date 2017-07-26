//
//  GFSettingViewController.m
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GFSettingViewController.h"
#import "ZZUser.h"
#import "ZZTypicalInformationModel.h"

#import "AboutZZViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface GFSettingViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

//@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
//@property (weak, nonatomic) NSString *priceRange;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray<NSString *> *reuseIDArray;
@property (strong , nonatomic)GFHTTPSessionManager *manager;
@property (strong, nonatomic) ZZUser *thisUser;

@property (strong, nonatomic) NSMutableArray<ZZTypicalInformationModel *> *industryArray;
@property (strong, nonatomic) NSMutableArray<ZZTypicalInformationModel *> *professionArray;
@property (strong, nonatomic) NSMutableArray<ZZTypicalInformationModel *> *interestsArray;

@property (strong, nonatomic) NSMutableArray<NSString *> *industry;
@property (strong, nonatomic) NSMutableArray<NSString *> *profession;
@property (strong, nonatomic) NSMutableArray<NSString *> *interests;

@property (strong, nonatomic) NSMutableArray<NSString *> *selectedPickerArray;

@property (strong, nonatomic) NSString *selectedItem;

@end

@implementation GFSettingViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadNewData];
    self.navigationItem.title = @"Settings";
    _thisUser = [AppDelegate APP].user;
    //计算整个应用程序的缓存数据 --- > 沙盒（Cache）
    //NSFileManager
    //attributesOfItemAtPathe:指定文件路径，获取文件属性
    //把所有文件尺寸加起来    //获取缓存尺寸字符串赋值给cell的textLabel
    //[self registerCell];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerView)];
    
    //[self.view addGestureRecognizer:tap];

    [self setUpReuseIDArray];
    
    self.industry = [[NSMutableArray alloc] init];
    self.profession = [[NSMutableArray alloc] init];
    self.interests = [[NSMutableArray alloc] init];
    [self loadIndustryData];
    //[self loadProfessionData];
    //[self loadInterestsData];
    [self setUpPickerView];
    
}
- (void)dismissPickerView {
    [self.picker resignFirstResponder];
}

- (void)setUpPickerView {
    //_industryArray = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E", nil];
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 400, GFScreenWidth, 150)];
    _picker.dataSource = self;
    _picker.delegate = self;
    _picker.backgroundColor = [UIColor lightGrayColor];
}

- (void)setUpReuseIDArray {
    _reuseIDArray = [[NSMutableArray alloc] init];
    
    [_reuseIDArray insertObject:@"account" atIndex:0];
    [_reuseIDArray insertObject:@"basic" atIndex:1];

    for (int i = 2; i < 5; i++) {
        [_reuseIDArray insertObject:@"accessory" atIndex:i];
        NSLog(@"i = %zd", i);
    }
    
    [_reuseIDArray insertObject:@"indicator" atIndex:5];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    NSString *cellID = _reuseIDArray[indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cellID = @"buttons";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"cellID --- %@", cellID);
    
    if (cell == nil) {
        switch (indexPath.section) {
            case 0:{
                if (indexPath.row == 2) {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                  reuseIdentifier:cellID];
                    
                } else {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                                  reuseIdentifier:cellID];
                    
                }
                break;
            }
                
                
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                              reuseIdentifier:cellID];
                break;
                
            default:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                              reuseIdentifier:cellID];
                break;
        }
        
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {

            cell.textLabel.text = [AppDelegate APP].user.userUserName;
            //cell.detailTextLabel.text = [AppDelegate APP].user.userEmail;
            cell.detailTextLabel.text = _thisUser.userEmail;
            cell.imageView.image = [AppDelegate APP].user.userProfileImage_UIImage;
            cell.imageView.frame = CGRectMake(0, 0, 30, 30);
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            accessoryLabel.text = @"Log Out >";
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
            cell.accessoryView = accessoryLabel;
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"Login with Facebook";
            //cell.detailTextLabel.text = @"You have logined with FB";
            cell.imageView.image = [UIImage imageNamed:@"ic_facebook"];
            UILabel *accessoryLabel = [[UILabel alloc] init];
            accessoryLabel.text = @"Connected";
            [cell.accessoryView addSubview:accessoryLabel];
            
        } else if (indexPath.row == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = @"Language";
            [cell.contentView addSubview:label];
            
            CGFloat btnWidth = (GFScreenWidth - 20 - 10) / 2;
            
            UIButton *enButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, btnWidth, 30)];
            [enButton addTarget:self action:@selector(enButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [enButton setTitle:@"English" forState:UIControlStateNormal];
            [enButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enButton.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            enButton.layer.cornerRadius = 5.0f;
            enButton.layer.masksToBounds = YES;
            
            UIButton *twButton = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 20, 25, btnWidth, 30)];
            [twButton addTarget:self action:@selector(twButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [twButton setTitle:@"中文" forState:UIControlStateNormal];
            [twButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            twButton.backgroundColor = [UIColor grayColor];
            twButton.layer.cornerRadius = 5.0f;
            twButton.layer.masksToBounds = YES;

            [cell.contentView addSubview:enButton];
            [cell.contentView addSubview:twButton];
        }
    }
    
    else if (indexPath.section == 1) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Age";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_thisUser.age] ;
        
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Gender";
            cell.detailTextLabel.text = _thisUser.gender;
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = _thisUser.phone;
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Industry";
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Profession";
            
        } else if (indexPath.row == 5) {
           cell.textLabel.text = @"Interests";
        
        } 
    }
    
    else if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Anyone can view my profile.";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Anyone can message me.";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            cell.textLabel.text = @"Let me friends see my email address.";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        }
    }
    
    else if (indexPath.section == 3) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Allow Notification";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([_thisUser.allowNotification isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        }
    }
    
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Email Notification";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            if ([_thisUser.emailNotification isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            //[switchView release];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Sounds";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([_thisUser.sounds isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Show on Lock Screeen";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([_thisUser.showOnLockScreen isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }

    else if (indexPath.section == 5) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"About Zuzu";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Message Admin";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"Version 1.0";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 65.0f;
        } else {
            return 50.0f;
        }
    }
    return 44.0f;
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

//********************* didSelectRowAtIndexPath **************************//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            if (self.industry.count == 0) {
                [self loadIndustryData];
            }
            self.selectedPickerArray = [[NSMutableArray alloc]initWithArray:self.industry];
            NSLog(@"self.industry %@", self.industry);
            NSLog(@"self.selectedPickerArray %@", self.selectedPickerArray);
            NSLog(@"self.industryArray in didSelectRow %@", self.industryArray);
            [self.view addSubview:_picker];
            [_picker reloadAllComponents];
        }
        else if (indexPath.row == 4) {
            if (self.profession.count == 0) {
                [self loadProfessionData];
            }
            self.selectedPickerArray = [[NSMutableArray alloc]initWithArray:self.profession];
            NSLog(@"self.selectedPickerArray %@", self.selectedPickerArray);
            [self.view addSubview:_picker];
            [_picker reloadAllComponents];
        }
        else if (indexPath.row == 5) {
            if (self.interests.count == 0) {
                [self loadInterestsData];
            }
            
            self.selectedPickerArray = [[NSMutableArray alloc]initWithArray:self.interests];;
            NSLog(@"self.selectedPickerArray %@", self.selectedPickerArray);
            [self.view addSubview:_picker];
            [_picker reloadAllComponents];
        }
    }
    
    else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            AboutZZViewController *aboutZZVC = [[AboutZZViewController alloc] init];
            [self.navigationController pushViewController:aboutZZVC animated:YES];
        }
    }
}

//*********************** table view data **************************//
- (void)loadNewData {
 
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userID = [AppDelegate APP].user.userID;
    
    NSLog(@"userID %@", userID);
    NSDictionary *inSubData = @{@"memberId" : userID};
    NSDictionary *inData = @{@"action" : @"getProfile", @"token" : userToken, @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];

}

//*********************** picker view **************************//
#pragma -picker data
- (void)loadIndustryData {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get industry array-----------------//
    NSDictionary *inData = @{@"action" : @"getIndustryList", @"token" : userToken};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.industryArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSLog(@"industry array %@", _industryArray);
        
        for (int i = 0; i < _industryArray.count; i++) {
            [self.industry addObject:_industryArray[i].informationName.en];
        }
        NSLog(@"industry  %@", _industry);
        [self loadProfessionData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for industry, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)loadProfessionData {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get profession array-----------------//
    
    NSDictionary *inData1 = @{@"action" : @"getProfessionList", @"token" : userToken};
    
    NSDictionary *parameters1 = @{@"data" : inData1};
    
    [_manager POST:GetURL parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.professionArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        for (int i = 0; i < _professionArray.count; i++) {
            [self.profession addObject:_professionArray[i].informationName.en];
        }
        [self loadInterestsData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for profession, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)loadInterestsData {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    //NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get interests array-----------------//
    NSDictionary *inData2 = @{@"action" : @"getInterestList"};
    
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.interestsArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //self.interests = [[NSMutableArray alloc] init];
        for (int i = 0; i < _interestsArray.count; i++) {
            [self.interests addObject:_interestsArray[i].informationName.en];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for interest, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}


#pragma -picke view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
   
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pivkerView numberOfRowsInComponent:(NSInteger)component{
   
    return [_selectedPickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
    return [_selectedPickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedItem = [_selectedPickerArray objectAtIndex:row];
    NSLog(@"_selectedItem %@", _selectedItem);
    [_picker removeFromSuperview];
}

@end
