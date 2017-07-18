//
//  ZZCommentsTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZCommentsTableViewController.h"
#import "ZZComment.h"
#import "GFCommentCell.h"
#import "CommentHeaderView.h"

#import <MJExtension.h>

static NSString *const ID = @"ID";

@interface ZZCommentsTableViewController ()

/*请求管理者*/
@property (weak ,nonatomic) GFHTTPSessionManager *manager;
/** 最新评论数据 */
@property (nonatomic, strong) NSMutableArray<ZZComment *> *comments;

@property (strong, nonatomic) UIView *headerView;

@end

@implementation ZZCommentsTableViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpHeadView
{
    
    /*
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.gf_width, 230)];
    self.headerView = headerView;
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 50, 50)];
    [headerView addSubview:profileImageView];
    
    UILabel *smallTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 4, self.view.gf_width - 170, 16)];
    [headerView addSubview:smallTitleLabel];
    
    UILabel *bigTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 19, self.view.gf_width - 21, 16)];
     */
    
    //CommentHeaderView *headerView = [[CommentHeaderView alloc] initWithFrame: CGRectMake(0, 0, self.view.gf_width, 230)];
    //[self.tableView.tableHeaderView addSubview:headerView];

    
    //NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"GFEventsCell" owner:nil options:nil];
    //GFEventsCell *headerView = [views lastObject];
    //headerView.event = _content;
    //[self.tableView.tableHeaderView addSubview:headerView];
    
    
     //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFCommentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    //注册
    //[self.tableView registerClass:[GFCommentCell class] forHeaderFooterViewReuseIdentifier:headID];
    //嵌套一个View
    /*
    UIView *head = [[UIView alloc] init];
    GFTopicCell *topicCell = [GFTopicCell gf_viewFromXib];
    topicCell.backgroundColor = [UIColor whiteColor];
    topicCell.topic = self.topic;
    
    topicCell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeight);
    
    // 设置header的高度
    head.gf_height = topicCell.gf_height + GFMargin * 2;
    
    self.tableView.tableHeaderView = head;
    [head addSubview:topicCell];
    
    //头部View高度
    self.tableView.sectionHeaderHeight = [UIFont systemFontOfSize:13].lineHeight + GFMargin;
     */
}

/*
-(void)setUpRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
}

#pragma mark - 加载网络数据
-(void)loadNewComment
{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topic.ID;
    parameters[@"hot"] = @1;
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:GFBSURL parameters:parameters progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 没有任何评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
        
        // 字典数组转模型数组
        weakSelf.latestComments = [GFComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        weakSelf.hotestComments = [GFComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        NSInteger total = [responseObject[@"total"] intValue];
        if (weakSelf.latestComments.count == total) { // 全部加载完毕
            // 隐藏
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
