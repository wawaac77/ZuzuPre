//
//  ZZHomeViewController.m
//  GFBS
//
//  Created by Alice Jin on 12/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZHomeViewController.h"
#import "AllHomeTableViewController.h"
#import "FriendsHomeTableViewController.h"
#import "MeHomeTableViewController.h"
#import "LeaderboardViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@interface ZZHomeViewController () <UIScrollViewDelegate>

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

@property (weak ,nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation ZZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
    [self setUpTitleView];
    [self setUpChildViewControllers];
    [self setUpScrollView];
    //添加默认自控制器View
    [self addChildViewController];
}

- (void)setUpNavBar {
    
}

- (void)setUpTitleView {
    
    //UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
    //scroll.contentSize = CGSizeMake(320, 700);
    //scroll.showsHorizontalScrollIndicator = YES;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"All", @"Friends", @"Me", @"Leaderboard", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl = segmentedControl;
    segmentedControl.frame = CGRectMake(10, 5, GFScreenWidth - 20, 25);
    segmentedControl.tintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
    
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    [segmentedControl addTarget:self action:@selector(segmentControlAction:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
}

- (void)segmentControlAction : (UISegmentedControl *) segment {
    
    if (self.segmentedControl.selectedSegmentIndex == segment.selectedSegmentIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZSegmentTitleDidRepeatShowClickNotificationCenter" object:nil];
    }
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.gf_width * segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

-(void)setUpChildViewControllers
{
    //All
    AllHomeTableViewController *allVC = [[AllHomeTableViewController alloc] init];
    [self addChildViewController:allVC];
    
    //Friends
    FriendsHomeTableViewController *friendsVC = [[FriendsHomeTableViewController alloc] init];
    [self addChildViewController:friendsVC];
    
    //Me
    MeHomeTableViewController *meVC = [[MeHomeTableViewController alloc] init];
    [self addChildViewController:meVC];
    
    //Leaderboard
    LeaderboardViewController *leaderboardVC = [[LeaderboardViewController alloc] init];
    [self addChildViewController:leaderboardVC];

}

/**
 添加scrollView
 */
-(void)setUpScrollView
{
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 30, self.view.gf_width, self.view.gf_height - 30 - GFTabBarH);
    NSLog(@"self.view.gf_width in first claim scrollView is %f", self.view.gf_width);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.gf_width * self.childViewControllers.count, 0);
}

#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    //在这里面添加自控制器的View
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.gf_width;
    //取出自控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return; //判断添加就不用再添加了
    childVc.view.frame = CGRectMake(index * self.scrollView.gf_width, 0, self.scrollView.gf_width, self.scrollView.gf_height);
    NSLog(@"index is %ld", (long) index);
    [self.scrollView addSubview:childVc.view];
    
}

#pragma mark - <UIScrollViewDelegate>

/**
 点击动画后停止调用
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewController];
}


/**
 人气拖动的时候，滚动动画结束时调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //点击对应的按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.gf_width;
    UISegmentedControl *segmentControl = self.segmentedControl;
    segmentControl.selectedSegmentIndex = index;
    [self segmentControlAction:segmentControl];
    
    [self addChildViewController];
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

@end
