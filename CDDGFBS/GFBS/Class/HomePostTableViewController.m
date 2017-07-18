//
//  HomePostTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePostTableViewController.h"
#import "GFEventsCell.h"
#import "ZZContentModel.h"
//#import "GFCommentViewController.h"
#import "ZZCommentsTableViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";
//@class ZZContentModel;

@interface HomePostTableViewController ()

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *contents;
/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation HomePostTableViewController

#pragma mark - 消除警告
-(MyPublishContentType)type
{
    return 0;
}

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
    [self setUpTable];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //[self.tableView setFrame:self.view.bounds];
    NSLog(@"table width %f",self.view.gf_width);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //[self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = (GFEventsCell *)[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    ZZContentModel *thisContent = self.contents[indexPath.row];
    NSLog(@"this content%@", thisContent);
    
    cell.event = thisContent;
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZZCommentsTableViewController *commentVC = [[ZZCommentsTableViewController alloc] init];
    //commentVC.content = [_contents objectAtIndex:indexPath.row];
    //commentVC.view.frame = CGRectMake(0, ZZNewNavH, self.view.gf_width, self.view.gf_height - ZZNewNavH - GFTabBarH);
    NSLog(@"self.view.gf_width in GFUpcomingVC claim event detailVC is %f", self.view.gf_width);
    NSLog(@"self.view.gf_height in GFUpcomingVC claim event detailVC is %f", self.view.gf_height);
    //eventDetailVC. = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSLog(@"loadNewEvents工作了");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"user token %@", userToken);
    NSDictionary *inData = [[NSDictionary alloc] init];
    if (self.type == 0) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getFriendCheckinList", @"token" : userToken};
    } else if (self.type == 2) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken};
    }
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        self.contents = [ZZContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
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


@end
