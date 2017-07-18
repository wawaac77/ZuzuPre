//
//  MyZuzuViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyZuzuViewController.h"
#import "LeaderboardHomeTableViewController.h"

#import "GFWebViewController.h"
#import "GFSettingViewController.h"
#import "BadgesCollectionViewController.h"
#import "NotificationViewController.h"
#import "LeaderboardViewController.h"
#import "ZZFriendsTableViewController.h"

#import "EventListTableViewController.h"
#import "RestaurantViewController.h" //should be favourite restaurant


#import "GFSquareItem.h"
#import "GFSquareCell.h"
#import "ZGAlertView.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import "UIBarButtonItem+Badge.h"

static NSString *const ID = @"ID";
static NSInteger const cols = 2;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols

@interface MyZuzuViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<GFSquareItem *> *buttonItems;

/**collectionView*/
@property (weak ,nonatomic) UICollectionView *functionsCollectionView;

@end

@implementation MyZuzuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
    [self setUpCollectionItemsData];
    [self setUpFunctionsCollectionView];
}



#pragma mark - 设置底部视图
-(void)setUpFunctionsCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    NSLog(@"itemHW %f", itemHW);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *functionsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, GFScreenHeight) collectionViewLayout:layout];
    self.functionsCollectionView = functionsCollectionView;
    self.functionsCollectionView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:functionsCollectionView];
    //关闭滚动
    functionsCollectionView.scrollEnabled = NO;
    
    //设置数据源和代理
    functionsCollectionView.dataSource = self;
    functionsCollectionView.delegate = self;
    
    //注册
    [functionsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GFSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    //[self.functionsView addSubview:functionsCollectionView];
    //NSInteger rows = (_buttonItems.count - 1) /  cols + 1;
    //self.functionsView.gf_height = rows * itemHW + cols * margin ;
    
}

#pragma mark - Setup UICollectionView Data
-(void)setUpCollectionItemsData {
    NSArray *buttonIcons = [NSArray arrayWithObjects:@"zuzu-checkin", @"zuzu-leaderboard", @"invite-friends", @"my-friends", nil];
    NSArray *buttonTitles = [NSArray arrayWithObjects:@"Check-in", @"Leaderboard", @"Invite Friends", @"My Friends", nil];
    //NSMutableArray<GFSquareItem *> *buttonItems =[[NSMutableArray<GFSquareItem *> alloc]init];
    //self.buttonItems = buttonItems;
    self.buttonItems = [[NSMutableArray<GFSquareItem *> alloc]init];
    for (int i = 0; i < buttonIcons.count; i++) {
        GFSquareItem *squareItem = [[GFSquareItem alloc]init];
        squareItem.icon = buttonIcons[i];
        squareItem.name = buttonTitles[i];
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_buttonItems.count = %ld", _buttonItems.count);
    return _buttonItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSLog(@"indexPath.item%ld", indexPath.item);
    NSLog(@"buttonItems indexPath.item%@", self.buttonItems[indexPath.item].name);
    
    cell.item = self.buttonItems[indexPath.item];
    
    return cell;
}

- (void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    //notificationBtn.badgePadding = 0;
    //notificationBtn.badgeMinSize = 0; //I changed their default value in category
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = @"My Zuzu";
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareItem *item = _buttonItems[indexPath.item];
    
    if ([item.name isEqualToString: @"My Events"]) {
        EventListTableViewController *eventVC = [[EventListTableViewController alloc] init];
        [self.navigationController pushViewController:eventVC animated:YES];
    }
    else if ([item.name isEqualToString: @"Leaderboard"]) {
        LeaderboardHomeTableViewController *leaderboardVC = [[LeaderboardHomeTableViewController alloc] init];
        leaderboardVC.view.frame = CGRectMake(0, 0, GFScreenWidth, self.view.gf_height - GFTabBarH);
        leaderboardVC.navigationItem.title = @"Leaderboard";
        [self.navigationController pushViewController:leaderboardVC animated:YES];
    }
    else if ([item.name isEqualToString: @"Invite Friends"]) {
        [self showShareView];
    }
    else if ([item.name isEqualToString: @"My Friends"]) {
        ZZFriendsTableViewController *myFriendsVC = [[ZZFriendsTableViewController alloc] init];
        //myFriendsVC.view.frame = CGRectMake(0, 0, GFScreenWidth, self.view.gf_height - GFTabBarH);
        //myFriendsVC.navigationItem.title = @"My Friends";
        [self.navigationController pushViewController:myFriendsVC animated:YES];
    }

    //判断
    if (![item.url containsString:@"http"]) return;
    
    NSURL *url = [NSURL URLWithString:item.url];
    GFWebViewController *webVc = [[GFWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    //给Url赋值
    webVc.url = url;
    
}

- (void)showShareView {
    /*
    NSString *shareText = @"I'm having fun on ZUZU. Come and join me!";
    NSArray *itemsToShare = @[shareText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[];
    [self presentViewController:activityVC animated:YES completion:nil];
     */
    
    ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"Invite Friends" message:@"" cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
    [facebookButton setTitle:@"Find friends on Facebook" forState:UIControlStateNormal];
    [alertView addCustomButton:facebookButton toIndex:0];
    
    UIButton *googlePlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    googlePlusButton.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:72.0/255.0 blue:54.0/255.0 alpha:1];
    [googlePlusButton setTitle:@"Connect with Google+" forState:UIControlStateNormal];
    [alertView addCustomButton:googlePlusButton toIndex:1];
    
    UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    smsButton.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:194.0/255.0 blue:54.0/255.0 alpha:1];
    [smsButton setTitle:@"SMS Your Friends" forState:UIControlStateNormal];
    [alertView addCustomButton:smsButton toIndex:2];
    
    UIButton *shareUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareUrlButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0 alpha:1];
    [shareUrlButton setTitle:@"Share URL" forState:UIControlStateNormal];
    [alertView addCustomButton:shareUrlButton toIndex:3];
    
    alertView.titleColor = [UIColor whiteColor];
    alertView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithObjects:facebookButton, googlePlusButton, smsButton, shareUrlButton, nil];
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [buttonArray objectAtIndex:i];
        button.layer.cornerRadius = 5.0f;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }

    [alertView show];
    
}

- (void)settingClicked
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leaderboardButtonClicked:(id)sender {
    LeaderboardViewController *leaderboardVC = [[LeaderboardViewController alloc] init];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}
@end
