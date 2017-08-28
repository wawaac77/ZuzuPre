//
//  GFSettingViewController.m
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "InternationalControl.h"
#import "GFSettingViewController.h"
#import "ZZUser.h"
#import "ZZTypicalInformationModel.h"

#import "AboutZZViewController.h"
#import "ZZMessageAdminViewController.h"
#import "LoginViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>    
#import <SVProgressHUD.h>

@interface GFSettingViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

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

@property (strong, nonatomic) ZZTypicalInformationModel *selectedItem;

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
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    _thisUser = [AppDelegate APP].user;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageInVC) name:@"changeLanguageInVC" object:nil];
    
    [InternationalControl initUserLanguage];//初始化应用语言
    
    NSBundle *bundle = [InternationalControl bundle];
    
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Your Account", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Personal Information", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"Visibility", nil);
    } else if (section == 3) {
        return NSLocalizedString(@"System", nil);
    }
    
    return NULL;
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
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellID];
                } else {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                }
                break;
            }
                
                
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                break;
                
            default:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                break;
        }
    }

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {

            cell.textLabel.text = [AppDelegate APP].user.userUserName;
            cell.detailTextLabel.text = _thisUser.userEmail;
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            NSString *imageURL = [AppDelegate APP].user.userProfileImage.imageUrl;
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.layer.cornerRadius = myImageView.gf_width / 2;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFill;
            [myImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
            [cell.contentView addSubview:myImageView];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:15];
            accessoryLabel.text = NSLocalizedString(@"Log Out >", nil);
            [cell.contentView addSubview:accessoryLabel];
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"Login with Facebook";
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.image =[UIImage imageNamed:@"square-facebook-69x69"];
            myImageView.layer.cornerRadius = 5.0f;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:myImageView];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:15];
            accessoryLabel.text = NSLocalizedString(@"Connected", nil);
            [cell.contentView addSubview:accessoryLabel];
            
        } else if (indexPath.row == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = @"Language";
            [cell.contentView addSubview:label];
            
            CGFloat btnWidth = (GFScreenWidth - 20 - 10) / 2;
            
            UIButton *enButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, btnWidth, 30)];
            [enButton addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];
            [enButton setTitle:@"English" forState:UIControlStateNormal];
            [enButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enButton.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            enButton.layer.cornerRadius = 5.0f;
            enButton.layer.masksToBounds = YES;
            
            UIButton *twButton = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 20, 30, btnWidth, 30)];
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
            cell.textLabel.text = NSLocalizedString(@"Age", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_thisUser.age] ;
        
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Gender", nil);
            cell.detailTextLabel.text = _thisUser.gender;
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Phone", nil) ;
            cell.detailTextLabel.text = _thisUser.phone;
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"Industry", nil);
            cell.detailTextLabel.text = _thisUser.userIndustry.informationName;
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = NSLocalizedString(@"Profession", nil);
            cell.detailTextLabel.text = _thisUser.userProfession.informationName;
            
        } else if (indexPath.row == 5) {
            cell.textLabel.text = NSLocalizedString(@"Interests", nil);
            NSString *myInterests = @"";
            for (int i = 0; i < _thisUser.userInterests.count; i++) {
                myInterests = [[NSString stringWithFormat:@"%@ ", _thisUser.userInterests[i].informationName] stringByAppendingString: myInterests];
            }
            NSLog(@"myInterests %@", myInterests);
            cell.detailTextLabel.text = myInterests;
        } 
    }
    
    else if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Anyone can view my profile.", nil);
            if ([self.thisUser.canSeeMyProfile isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Anyone can message me.", nil);
            if ([self.thisUser.canMessageMe isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            cell.textLabel.text = NSLocalizedString(@"Let my friends see my email address.", nil);
            if ([self.thisUser.canMyFriendSeeMyEmail isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        }
    }
    
    else if (indexPath.section == 3) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString( @"Allow Notification", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = indexPath.row;
            cell.accessoryView = switchView;
            
            if ([_thisUser.allowNotification isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            switchView.tag = indexPath.row + 10 * indexPath.section;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        }
    }
    
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString( @"Email Notification", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            if ([_thisUser.emailNotification isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            switchView.tag = indexPath.row;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            //[switchView release];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Sounds", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([_thisUser.sounds isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            switchView.tag = indexPath.row;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Show on Lock Screen", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([_thisUser.showOnLockScreen isEqualToNumber:[NSNumber numberWithBool:true]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            switchView.tag = indexPath.row;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }

    else if (indexPath.section == 5) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString( @"About Zuzu", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Message Admin", nil) ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = NSLocalizedString(@"Version 1.0", nil) ;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 70.0f;
        } else {
            return 50.0f;
        }
    }
    return 44.0f;
}


- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog(@"sender.tag %@", switchControl.tag);
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

- (void)changeLanguage:(id)sender {
    NSLog(@"Change language button clicked");
    NSString *lan = [InternationalControl userLanguage];
    [InternationalControl setUserlanguage:@"zh-Hant"];
    
    /*
    if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
        
        
        
    }else{
        
        [InternationalControl setUserlanguage:@"en"];
    }
     */
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguageInVC" object:nil];
}

-(void)changeLanguageInVC{
    NSLog(@"reload VC");
    [self viewDidLoad];
}

- (void)enButtonClicked {
    NSLog(@"English button clicked");
    //*************** defualt user set even app is turned off *********//
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"en" forKey:@"KEY_USER_LANG"];
    [userDefaults synchronize];
    
    [AppDelegate APP].user.preferredLanguage = @"en";
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
    
    [InternationalControl setUserlanguage:@"en"];
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguageInVC" object:nil];
}

- (void)twButtonClicked {
    NSLog(@"Chinese button clicked");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"tw" forKey:@"KEY_USER_LANG"];
    [userDefaults synchronize];
    
    [AppDelegate APP].user.preferredLanguage = @"tw";
    
    
    [InternationalControl setUserlanguage:@"zh-Hant"];
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguageInVC" object:nil];

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [AppDelegate APP].user = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"KEY_USER_NAME"];
        [userDefaults setObject:nil forKey:@"KEY_USER_TOKEN"];
        [userDefaults synchronize];
        
        [appDel.window makeKeyAndVisible];
        [appDel.window setRootViewController:loginVC];
        
        /*
        id rootController = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
        if ([rootController isKindOfClass:[LoginViewController class]]){
            //do something
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
            
        }
         */

        
    }
}

//********************* didSelectRowAtIndexPath **************************//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Hi, mate", nil)  message:NSLocalizedString(@"Are you sure to log out?", nil)  delegate:self cancelButtonTitle: NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
            [alertView show];

        }
        
        
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            if (self.industry.count == 0) {
                [self loadIndustryData];
            }
            self.selectedPickerArray = [[NSMutableArray alloc]initWithArray:self.industry];
            NSLog(@"self.industry %@", self.industry);
            NSLog(@"self.selectedPickerArray %@", self.selectedPickerArray);
            NSLog(@"self.industryArray in didSelectRow %@", self.industryArray);
            [self.view insertSubview:_picker belowSubview:self.tableView];
            [_picker reloadAllComponents];
        }
        else if (indexPath.row == 4) {
            if (self.profession.count == 0) {
                [self loadProfessionData];
            }
            self.selectedPickerArray = [[NSMutableArray alloc]initWithArray:self.profession];
            NSLog(@"self.selectedPickerArray %@", self.selectedPickerArray);
             [self.view insertSubview:_picker belowSubview:self.tableView];
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
    else if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([self.thisUser.canSeeMyProfile isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                self.thisUser.canSeeMyProfile = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                self.thisUser.canSeeMyProfile = @1;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([self.thisUser.canMessageMe isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                self.thisUser.canMessageMe = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                self.thisUser.canMessageMe = @1;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([self.thisUser.canMyFriendSeeMyEmail isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                self.thisUser.canMyFriendSeeMyEmail = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                self.thisUser.canMyFriendSeeMyEmail = @1;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);

        }
    }

    else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            AboutZZViewController *aboutZZVC = [[AboutZZViewController alloc] init];
            [self.navigationController pushViewController:aboutZZVC animated:YES];
        }
        else if (indexPath.row == 1) {
            ZZMessageAdminViewController *adminVC = [[ZZMessageAdminViewController alloc] init];
            [self.navigationController pushViewController:adminVC animated:YES];
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
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Busy network, please try later~" , nil)];
        
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
    NSString *userLang = [AppDelegate APP].user.preferredLanguage;
    
    //----------------get industry array-----------------//
    NSDictionary *inData = @{@"action" : @"getIndustryList", @"token" : userToken, @"lang" : userLang};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.industryArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSLog(@"industry array %@", _industryArray);
        
        for (int i = 0; i < _industryArray.count; i++) {
            [self.industry addObject:_industryArray[i].informationName];
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
    NSString *userLang = [AppDelegate APP].user.preferredLanguage;
    
    //----------------get profession array-----------------//
    
    NSDictionary *inData1 = @{@"action" : @"getProfessionList", @"token" : userToken, @"lang" : userLang};
    
    NSDictionary *parameters1 = @{@"data" : inData1};
    
    [_manager POST:GetURL parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.professionArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        for (int i = 0; i < _professionArray.count; i++) {
            [self.profession addObject:_professionArray[i].informationName];
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
    
    NSString *userLang = [AppDelegate APP].user.preferredLanguage;
    
    //----------------get interests array-----------------//
    NSDictionary *inData2 = @{@"action" : @"getInterestList", @"lang": userLang};
    
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.interestsArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //self.interests = [[NSMutableArray alloc] init];
        for (int i = 0; i < _interestsArray.count; i++) {
            [self.interests addObject:_interestsArray[i].informationName];
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
    if ([self.tableView indexPathForSelectedRow].row == 3) {
        _thisUser.userIndustry = [_industryArray objectAtIndex:row];
    }
    else if ([self.tableView indexPathForSelectedRow].row == 4) {
        _thisUser.userProfession = [_professionArray objectAtIndex:row];
    }
    else if (([self.tableView indexPathForSelectedRow].row == 5)) {
        if (![_thisUser.userInterests containsObject:[_interestsArray objectAtIndex:row]]) {
            [_thisUser.userInterests addObject:[_interestsArray objectAtIndex:row]];
        } else {
            [_picker removeFromSuperview];
        }
        NSLog(@"_thisUser.userInterests %@", _thisUser.userInterests);
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"_selectedItem %@", _selectedItem);
    
    //[self updateProfile];
    [_picker removeFromSuperview];
   
}

- (void)updateProfile {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get profession array-----------------//
    
    
    NSDictionary *inSubData2 = @{
                                //@"name" : _thisUser.usertName,
                                //@"interests" : _thisUser.userInterests,
                                //@"maxPrice" : _thisUser.maxPrice,
                                //@"minPrice" : _thisUser.minPrice,
                                //@"allowNotification" : _thisUser.allowNotification,
                                //@"emailNotification" : _thisUser.emailNotification,
                                //@"allowNotification" : _thisUser.allowNotification,
                                //@"sounds" : _thisUser.sounds,
                                //@"showOnLockScreen" : _thisUser.showOnLockScreen,
                                //@"industry" : _thisUser.userIndustry.informationID,
                                //@"profession" : _thisUser.profession.informationID,
                                 //@"preferredLanguag" :
                                @"age" : _thisUser.age,
                                //@"phone" : _thisUser.phone,
                                //@"gender" :_thisUser.gender
                                };
    NSDictionary *inData2 = @{@"action" : @"updateProfile", @"token" : userToken, @"data" : inSubData2,
                             @"canSeeMyProfile" : _thisUser.canSeeMyProfile,
                             @"canMessageMe" : _thisUser.canMessageMe,
                             @"canMyFriendSeeMyEmail" : _thisUser.canMyFriendSeeMyEmail};
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for profession, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self updateProfile];
}

/*
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
    NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}
 */

@end
