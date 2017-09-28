//
//  GFSettingViewController.m
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
//#import "InternationalControl.h"

#import "GFTabBarController.h"
#import "ZBLocalized.h"
#import "GFSettingViewController.h"
#import "ZZUser.h"
#import "ZZTypicalInformationModel.h"
#import "CuisineTableViewController.h"

#import "AboutZZViewController.h"
#import "ZZMessageAdminViewController.h"
#import "LoginViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>    
#import <SVProgressHUD.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GFSettingViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *reuseIDArray;
@property (strong , nonatomic)GFHTTPSessionManager *manager;
@property (strong, nonatomic) ZZUser *thisUser;

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
    NSLog(@"changeLanguage viewDidLoad");
    
    self.navigationItem.title = ZBLocalized(@"Settings", nil);
    _thisUser = [[ZZUser alloc] init];
    _thisUser = [ZZUser shareUser];
    
    [self setUpReuseIDArray];
    [self toggleAuthUI];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    
    //google
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    //计算整个应用程序的缓存数据 --- > 沙盒（Cache）
    //NSFileManager
    //attributesOfItemAtPathe:指定文件路径，获取文件属性
    //把所有文件尺寸加起来    //获取缓存尺寸字符串赋值给cell的textLabel
    //[self registerCell];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerView)];
    
    //[self.view addGestureRecognizer:tap];

    
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
        return ZBLocalized(@"Your Account", nil);
    } else if (section == 1) {
        return ZBLocalized(@"Personal Information", nil);
    } else if (section == 2) {
        return ZBLocalized(@"Visibility", nil);
    } else if (section == 3) {
        return ZBLocalized(@"System", nil);
    }
    
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    NSString *cellID = _reuseIDArray[indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        cellID = @"buttons";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    NSLog(@"cellID --- %@", cellID);
    
    if (cell == nil) {
        switch (indexPath.section) {
            case 0:{
                if (indexPath.row == 3) {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                } else {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                }
                break;
            }
                
                
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
                break;
                
            default:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
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
            accessoryLabel.text = ZBLocalized(@"Log Out >", nil);
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
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:accessoryLabel];
            
            if ([ZZUser shareUser].userFacebookID == NULL) {
            
                //accessoryLabel.text = ZBLocalized(@"Not connected", nil);
                
            } else {
                accessoryLabel.text = ZBLocalized(@"Connected", nil);
            }
            
        }
        
        else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"Login with Goolge";
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.image =[UIImage imageNamed:@"google-plus-2-512 copy.png"];
            myImageView.layer.cornerRadius = 5.0f;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:myImageView];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:accessoryLabel];
            
            if ([ZZUser shareUser].userFacebookID == NULL) {
                //accessoryLabel.text = ZBLocalized(@"Not connected", nil);
            } else {
                
                accessoryLabel.text = ZBLocalized(@"Connected", nil);
            }
            
        }
        
        else if (indexPath.row == 3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = ZBLocalized(@"Language", nil);
            [cell.contentView addSubview:label];
            
            CGFloat btnWidth = (GFScreenWidth - 20 - 10) / 2;
            
            UIButton *enButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, btnWidth, 30)];
            [enButton addTarget:self action:@selector(enButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
            cell.textLabel.text = ZBLocalized(@"Age", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_thisUser.age] ;
        
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Gender", nil);
            cell.detailTextLabel.text = _thisUser.gender;
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = ZBLocalized(@"Phone", nil) ;
            cell.detailTextLabel.text = _thisUser.phone;
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = ZBLocalized(@"Industry", nil);
            cell.detailTextLabel.text = _thisUser.userIndustry.informationName;
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = ZBLocalized(@"Profession", nil);
            cell.detailTextLabel.text = _thisUser.userProfession.informationName;
            
        } else if (indexPath.row == 5) {
            cell.textLabel.text = ZBLocalized(@"Interests", nil);
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
            cell.textLabel.text = ZBLocalized(@"Anyone can view my profile.", nil);
            if ([self.thisUser.canSeeMyProfile isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Anyone can message me.", nil);
            if ([self.thisUser.canMessageMe isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            cell.textLabel.text = ZBLocalized(@"Let my friends see my email address.", nil);
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
            cell.textLabel.text = ZBLocalized( @"Allow Notification", nil);
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
            cell.textLabel.text = ZBLocalized( @"Email Notification", nil);
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
            cell.textLabel.text = ZBLocalized(@"Sounds", nil);
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
            cell.textLabel.text = ZBLocalized(@"Show on Lock Screen", nil);
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
            cell.textLabel.text = ZBLocalized( @"About Zuzu", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Message Admin", nil) ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = ZBLocalized(@"Version 0.5", nil) ;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
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

/*
- (void)changeLanguage:(id)sender {
    /*
    NSLog(@"Change language button clicked");
    NSString *lan = [InternationalControl userLanguage];
    [InternationalControl setUserlanguage:@"zh-Hant"];
     */
    
    /*
    if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
        
        
        
    }else{
        
        [InternationalControl setUserlanguage:@"en"];
    }
     */
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
/*
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"切换后的语言:%@",language);
}
*/

/*
-(void)changeLanguageInVC{
    NSLog(@"reload VC");
    [self viewDidLoad];
}
 */

- (void)enButtonClicked {
    NSLog(@"English button clicked");
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    
    if ([language isEqualToString:@"en"]) {
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
        alertView.tag = 1;
        [alertView show];
    }
    
    NSLog(@"切换后的语言:%@",language);
}

- (void)twButtonClicked {
    NSLog(@"Chinese button clicked");
   
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    
    if ([language isEqualToString:@"en"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
        alertView.tag = 2;
        [alertView show];
        
    } else {
        
    }

    //NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"切换后的语言:%@",language);

}

- (void)initRootVC{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[GFTabBarController alloc]init];
    [window makeKeyWindow];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    UIAlertView *alert = alertView;
    //log out
    if (buttonIndex == 1 && alertView.tag == 0) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [AppDelegate APP].user = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"KEY_USER_NAME"];
        [userDefaults setObject:nil forKey:@"KEY_USER_TOKEN"];
        [userDefaults synchronize];
        
        [appDel.window makeKeyAndVisible];
        [appDel.window setRootViewController:loginVC];
       
    // change to English
    } else if (alertView.tag == 1 && buttonIndex == 1) {
        [[ZBLocalized sharedInstance]setLanguage:@"en"];
        [self initRootVC];
        
    //change to Chinese
    } else if (alertView.tag == 2 && buttonIndex == 1) {
        [[ZBLocalized sharedInstance]setLanguage:@"zh-Hant"];
        [self initRootVC];
    }
}

//********************* didSelectRowAtIndexPath **************************//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
            alertView.tag = 0;
            [alertView show];

        }
        else if (indexPath.row == 1) {
            [self loginFBButtonClicked];
            
        }
        
        else if (indexPath.row == 2) {
            [self loginWithGoogleClicked];
        }

    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Industry";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];

            
        }
        else if (indexPath.row == 4) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Profession";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        }
        else if (indexPath.row == 5) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Interests";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
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
- (void)changeLanguage {
    NSLog(@"changeLanguage");
    
    //[[InternationalControl sharedInstance]
    //[self viewDidLoad];
    [self.tableView reloadData];
}
 */

//************************* pass value delegate ****************************//
- (void)passValueCuisine:(ZZUser *)theValue {
    
    /*
    if (theValue.userIndustry != NULL) {
        [ZZUser shareUser].userIndustry = theValue.userIndustry;
    }
     */
    
    [self.tableView reloadData];
}

#pragma mark - Facebook
//************************login with Facebook *******************************//
- (void)loginFBButtonClicked {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             NSLog(@"facebookToken %@", result.token);
             
         }
     }];
}

//************************ End of login with Facebook *******************************//

#pragma mark - Google
//************************* Google signin **************************//

- (void)loginWithGoogleClicked {
    [[GIDSignIn sharedInstance] signIn];
    //self.googlePlusLogoutButtonInstance.enabled=YES;
    
}

/*
 - (void)googlePlusLogoutButtonClick {
 [[GIDSignIn sharedInstance] signOut];
 //[[GPPSignIn sharedInstance] signOut];
 [[GIDSignIn sharedInstance] disconnect];
 self.googlePlusLogoutButtonInstance.enabled=NO;
 [_userDefaults removeObjectForKey:@"googlePlusLogin"];
 [_userDefaults synchronize];
 }
 */


- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleAuthUI {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        // Not signed in
        //self.statusText.text = @"Google Sign in\niOS Demo";
        //self.signInButton.hidden = NO;
        //self.signOutButton.hidden = YES;
        //self.disconnectButton.hidden = YES;
    } else {
        // Signed in
        //self.signInButton.hidden = YES;
        //self.signOutButton.hidden = NO;
        //self.disconnectButton.hidden = NO;
    }
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

//************************* end of Google signin part **************************//


/*
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
    NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}
 */

@end
