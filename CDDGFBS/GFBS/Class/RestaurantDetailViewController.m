//
//  RestaurantDetailViewController.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantOverviewViewController.h"
#import "RestaurantReviewViewController.h"
#import "RestaurantPhotoViewController.h"
#import "RestaurantMenuViewController.h"
#import "RestaurantEventViewController.h"
#import "GFTitleButton.h"

@interface RestaurantDetailViewController () <UIScrollViewDelegate>

/*当前选中的Button*/
@property (weak ,nonatomic) GFTitleButton *selectTitleButton;

/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView ;

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*标题栏*/
@property (weak ,nonatomic) UIScrollView *titleView;

/*TopImageView*/
@property (weak ,nonatomic) UIImageView *topImageView ;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
    
    [self setUpTopImageView];
    
    [self setUpChildViewControllers];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    //添加默认自控制器View
    [self addChildViewController];
}

-(void)setUpChildViewControllers
{
    //Overview
    RestaurantOverviewViewController *overviewVC = [[RestaurantOverviewViewController alloc] init];
    overviewVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:overviewVC];
    
    //Review
    RestaurantReviewViewController *reviewVC = [[RestaurantReviewViewController alloc] init];
    reviewVC.view.backgroundColor = [UIColor orangeColor];
    [self addChildViewController:reviewVC];
    
    //Photo
    RestaurantPhotoViewController *photoVC = [[RestaurantPhotoViewController alloc] init];
    photoVC.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:photoVC];
    
    //Menu
    RestaurantMenuViewController *menuVC = [[RestaurantMenuViewController alloc] init];
    menuVC.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:menuVC];
    
    //Event
    RestaurantEventViewController *eventVC = [[RestaurantEventViewController alloc] init];
    eventVC.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:eventVC];

    
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
    scrollView.frame = CGRectMake(0, 135, self.view.gf_width, 1000);
    NSLog(@"self.view.gf_width in first claim scrollView is %f", self.view.gf_width);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.gf_width * self.childViewControllers.count, 0);
}


/**
 添加标题栏View
 */
-(void)setUpTitleView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *titleView = [[UIScrollView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    self.titleView = titleView;
    
    titleView.delegate = self;
    titleView.frame = CGRectMake(0, 100, self.view.gf_width, 35);
    titleView.contentSize = CGSizeMake(self.view.gf_width + 50, 35);
    NSLog(@"self.view.gf_width in first claim scrollView is %f", self.view.gf_width);
    titleView.pagingEnabled = YES;
    titleView.scrollEnabled = YES;
    titleView.showsVerticalScrollIndicator = NO;
    titleView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleView];
    
    /*
    UIScrollView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    titleView.frame = CGRectMake(0, 200 , self.view.gf_width + 100, 35);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    [self.view addSubview:titleView];
     */
    
    NSArray *titleContens = @[@"Overview",@"Review",@"Photo",@"Menu", @"Event"];
    NSInteger count = titleContens.count;
    NSLog(@"titlecontents count is %ld", (long)count);
    
    CGFloat titleButtonW = titleView.contentSize.width / count;
    NSLog(@"titleView.gf_width is %f", titleView.gf_width);
    NSLog(@"titleButtonW is %f", titleButtonW);
    CGFloat titleButtonH = titleView.gf_height;
    
    for (NSInteger i = 0; i < count; i++) {
        GFTitleButton *titleButton = [GFTitleButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.tag = i; //绑定tag
        [titleButton addTarget:self action:@selector(titelClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titleContens[i] forState:UIControlStateNormal];
        CGFloat titleX = i * titleButtonW;
        NSLog(@"i is %ld", (long) i);
        NSLog(@"titleX is %f", titleX);
        titleButton.frame = CGRectMake(titleX, 0, titleButtonW, titleButtonH);
        
        [titleView addSubview:titleButton];
        
    }
    //按钮选中颜色
    GFTitleButton *firstTitleButton = titleView.subviews.firstObject;
    //底部指示器
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    
    indicatorView.gf_height = 2;
    indicatorView.gf_y = titleView.gf_height - indicatorView.gf_height;
    
    [titleView addSubview:indicatorView];
    
    //默认选择第一个全部TitleButton
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.gf_width = firstTitleButton.titleLabel.gf_width;
    indicatorView.gf_centerX = firstTitleButton.gf_centerX;
    [self titelClick:firstTitleButton];
}

/**
 标题栏按钮点击
 */
-(void)titelClick:(GFTitleButton *)titleButton
{
    if (self.selectTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter]postNotificationName:GFTitleButtonDidRepeatShowClickNotificationCenter object:nil];
    }
    
    //控制状态
    self.selectTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectTitleButton = titleButton;
    
    //指示器
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.gf_width = titleButton.titleLabel.gf_width;
        self.indicatorView.gf_centerX = titleButton.gf_centerX;
    }];
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.gf_width * titleButton.tag;
    [self.scrollView setContentOffset:offset animated:YES];
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
    GFTitleButton *titleButton = self.titleView.subviews[index];
    
    [self titelClick:titleButton];
    
    [self addChildViewController];
}

- (void)setUpTopImageView
{
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.gf_width, 100)];
    self.topImageView = topImageView;
    topImageView.backgroundColor = [UIColor blackColor];
    topImageView.image = [UIImage imageNamed:@"pexels-photo-262918.png"];
    [self.view addSubview:topImageView];
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 0.0f;
    //左边
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButten)];
    
    //TitieView
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //self.navigationItem.title = @"Search Bar should be here!";
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
