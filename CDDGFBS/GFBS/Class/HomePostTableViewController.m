//
//  HomePostTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBLocalized.h"
#import "HomePostTableViewController.h"
#import "GFEventsCell.h"
#import "ZZContentModel.h"
#import "NotificationItem.h"
//#import "ZZCommentsViewController.h"
#import "GFCommentViewController.h"
#import "RestaurantDetailViewController.h"
#import "UserProfileCheckinViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>

static NSString *const ID = @"ID";
//@class ZZContentModel;

@interface HomePostTableViewController () <FBSDKSharingDelegate> {
    int contentCellHeightCount;
    int deleteIndex;
    
    int currentPage;
}

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *contents;

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *selectedContents;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) NSIndexPath *recordIndexPath;

@property (strong, nonatomic) NotificationItem *prizeInfo;

@end


@implementation HomePostTableViewController

#pragma mark - 消除警告
-(MyPublishContentType)type
{
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contentCellHeightCount = 0;
    deleteIndex = -1;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    currentPage = 2;
    
    [self setUpTable];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 tableView
 */
-(void)setUpTable
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        // 如果tableView响应了setSeparatorInset: 这个方法,我们就将tableView分割线的内边距设为0.
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        // 如果tableView响应了setLayoutMargins: 这个方法,我们就将tableView分割线的间距距设为0.
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 400;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    if (self.type == 0) {
        [self getBannerInfo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZContentModel *content = _contents[indexPath.row];
    return content.cellHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //**** set up restaurant button **//
    UIButton *restaurantButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 16, 264, 30)];
    restaurantButton.backgroundColor = [UIColor clearColor];
    [restaurantButton addTarget:self action:@selector(restaurantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    restaurantButton.tag = indexPath.row;
    [cell.contentView addSubview:restaurantButton];
    
    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 50, 50)];
    profileImageButton.backgroundColor = [UIColor clearColor];
    [profileImageButton addTarget:self action:@selector(profileImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    profileImageButton.tag = indexPath.row;
    [cell.contentView addSubview:profileImageButton];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(GFScreenWidth - 60, 8, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"ic_fa-ellipsis-h"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = indexPath.row;
    [cell.contentView addSubview:deleteButton];
    
    cell.event = self.contents[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *recordIndexPath = [[NSIndexPath alloc] init];
    self.recordIndexPath = recordIndexPath;
    recordIndexPath = indexPath;
    
    GFCommentViewController *commentsVC = [[GFCommentViewController alloc] init];
    commentsVC.topic = [_contents objectAtIndex:indexPath.row];
    if (self.contents[indexPath.row].listImage_UIImage == NULL) {
        NSLog(@"UIImage is null");
    }
    commentsVC.view.frame = CGRectMake(0, ZZNewNavH, self.view.gf_width, self.view.gf_height - ZZNewNavH - GFTabBarH);
    commentsVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:commentsVC animated:YES];
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 这两句的含义跟上面两句代码相同,就不做解释了
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/**
 button clicked
 */
#pragma mark - button clicked
- (void)restaurantButtonClicked: (UIButton *) sender {
    ZZContentModel *thisContent = _contents[sender.tag];
    RestaurantDetailViewController *restaurantVC = [[RestaurantDetailViewController alloc] init];
    restaurantVC.thisRestaurant = thisContent.listEventRestaurant;
    [self.navigationController pushViewController:restaurantVC animated:YES];
}

- (void)profileImageButtonClicked: (UIButton *) sender {
    ZZContentModel *thisContent = _contents[sender.tag];
    UserProfileCheckinViewController *userVC = [[UserProfileCheckinViewController alloc] init];
    userVC.myProfile = thisContent.listPublishUser;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)deleteButtonClicked: (UIButton *) sender {
    //ZZContentModel *thisContent = _contents[sender.tag];
    deleteIndex = sender.tag;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:ZBLocalized(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [actionSheet addButtonWithTitle:ZBLocalized(@"Share to Facebook", nil)]; //tag1
    //[actionSheet addButtonWithTitle:ZBLocalized(@"Share to Google", nil)]; //tag2
    
    if (self.type == 2) {
        [actionSheet addButtonWithTitle:ZBLocalized(@"Delete", nil)];
    }

    [actionSheet showInView:self.view];
}

/*
 //Google+ deprecated
- (void)shareToGoogleClicked {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder setURLToShare:[NSURL URLWithString:@"https://www.example.com/restaurant/sf/1234567/"]];
    [shareBuilder open];
}
*/

- (void)shareToFacebookClicked {
    ZZContentModel *thisContent = _contents[deleteIndex];
    NSURL *URL = [NSURL URLWithString:thisContent.listImage.imageUrl];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    UIImage *image = [[UIImage alloc]initWithData:data];
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    
    /*
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.quote = thisContent.listMessage;
    */
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    //content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"]; //could be the app's link
    
    //FBSDKShareMediaContent *content = [FBSDKShareMediaContent new];
    //content.media = @[photo, linkContent];
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];


}

/**
 action sheet
 */
#pragma mark - actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 3) {
        ZZContentModel *thisContent = _contents[deleteIndex];
        [self.contents removeObjectAtIndex:deleteIndex];
        [self.tableView reloadData];
    
        NSString *userToken = [AppDelegate APP].user.userToken;
        NSDictionary *inSubData = @{@"checkinId" : thisContent.listEventID};
        NSDictionary *inData = @{@"action" : @"deleteMyCheckinPost", @"token" : userToken, @"data" : inSubData};
        NSDictionary *parameters = @{@"data" : inData};
        
        [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
  
        } failed:^(NSError *error) {
            [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
            [SVProgressHUD dismiss];
        }];
    } else if (buttonIndex == 1) {
        NSLog(@"share to facebook");
        [self shareToFacebookClicked];
    } else if (buttonIndex == 2) {
        NSLog(@"share to google");
    }
}

#pragma mark - refresh
- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 api
 */
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    currentPage = 2;
    
    NSString *userToken = [ZZUser shareUser].userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSLog(@"preferred language [AppDelegate APP].user.preferredLanguage %@", userLang);
    
    NSLog(@"user token %@", userToken);
    
    NSDictionary *inSubData = @{@"page" : @1};
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    if (self.type == 0) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getFriendCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 2) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 4) {
        NSDictionary *inSubData = @{@"restaurantId" : self.restaurantID};
        inData = @{@"action" : @"getRestaurantCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 5) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    }
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.contents = [ZZContentModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        for (int i = 0; i < self.contents.count; i++) {
            if (self.contents[i].numOfLike == NULL) {
                self.contents[i].numOfLike = 0;
            }
            NSString *str = [self.contents[i].listImage.imageUrl pathExtension];
            
            if ([str isEqualToString:@"undefined"] || str == NULL) {
                self.contents[i].withImage = @0;
            } else {
                self.contents[i].withImage = @1;
            }
        }
        
        self.selectedContents = [[NSMutableArray alloc] init];
        
        [self passValueMethod];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];

}

#pragma mark - 加载更多数据
-(void)loadMoreData
{
    NSLog(@"loadMoreData工作了");
    if (currentPage == 0) {
        [self.tableView.mj_footer endRefreshing];
        return;
    } // if no new data
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSLog(@"current page %zd", currentPage);
    NSNumber *pageParameter = [[NSNumber alloc] initWithInt:currentPage];
    
    NSDictionary *inSubData = @{@"page" : pageParameter};
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    if (self.type == 0) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getFriendCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 2) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 4) {
        NSDictionary *inSubData = @{@"restaurantId" : self.restaurantID};
        inData = @{@"action" : @"getRestaurantCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    } else if (self.type == 5) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken, @"lang" : userLang, @"data":inSubData};
    }
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSMutableArray<ZZContentModel *> *moreData = [ZZContentModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        if (moreData.count != 0) {
            [self.contents addObjectsFromArray:moreData];
            
            int start = (int)(self.contents.count - moreData.count);
            
            for (int i = start; i < self.contents.count; i++) {
                
                if (self.contents[i].numOfLike == NULL) {
                    self.contents[i].numOfLike = 0;
                }
                NSString *str = [self.contents[i].listImage.imageUrl pathExtension];
               
                if ([str isEqualToString:@"undefined"] || str == NULL) {
                    self.contents[i].withImage = @0;
                } else {
                    self.contents[i].withImage = @1;
                }
            }
            currentPage ++;
        } else {
            currentPage = 0;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
}

- (void)getBannerInfo {

    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{@"action" : @"getPrizeInfo", @"token" : userToken, @"lang" : userLang};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.prizeInfo = [NotificationItem mj_objectWithKeyValues:data[@"data"]];
        NSLog(@"prize %@", self.prizeInfo.notificationText);
        
        [self setupBannerView];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
}

/**
 setUp banner
 */
#pragma mark - setup bannerView
- (void)setupBannerView {
    
    CGFloat bannerH = 60;
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, bannerH)];

    NSURL *URL = [NSURL URLWithString:_prizeInfo.image.imageUrl];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    UIImage *image = [[UIImage alloc]initWithData:data];
    bannerView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, bannerH - 20, bannerH - 20)];
    icon.image = [UIImage imageNamed:@"medal"];
    [bannerView addSubview:icon];
    
    UILabel *bannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(bannerH, 10, GFScreenWidth - bannerH + 10, bannerH - 20)];
    bannerLabel.text = _prizeInfo.notificationText;
    [bannerView addSubview:bannerLabel];
    
    self.tableView.tableHeaderView = bannerView;
}


- (void)passValueMethod {
    NSInteger *num = self.contents.count;
    NSLog(@"passValueMethod %zd", num);
    [_delegate passValue:num];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

/**
 update cell which is hearted in commentVC
 */
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
