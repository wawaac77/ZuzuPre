//
//  ZZCheckInViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZCheckInViewController.h"
#import "DPSharePopView.h"
#import "DropDownListView.h"
#import "GFAddToolBar.h"
#import "GFPlaceholderTextView.h"

@interface ZZCheckInViewController () <UITextViewDelegate> {
    NSMutableArray *chooseArray;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;

/** 文本输入控件 */
@property (nonatomic, weak) GFPlaceholderTextView *textView;
@property (nonatomic, weak) GFAddToolBar *toolBar;

@property (weak, nonatomic) NSMutableArray *locationArray;

@end

@implementation ZZCheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNewData];
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpPostView];
    //[self loadNeweData];
    //[self setUpTopView];
}

- (void)setUpNavBar {
    
    [self preferredStatusBarStyle];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
 
}


- (void)setUpTopView {
    _topProfileImageView.layer.cornerRadius = _topProfileImageView.frame.size.width / 2;
    _topProfileImageView.clipsToBounds = YES;
    _topProfileImageView.image = [UIImage imageNamed:@"profile_image_animals.jpeg"];
    
    _locationButton.layer.borderWidth = 1.0f;
    _locationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _locationButton.layer.cornerRadius = 4.0f;
    _locationButton.clipsToBounds = YES;
    
   
}

- (void)loadNewData {
    NSMutableArray *locationArray = [[NSMutableArray alloc] initWithObjects:@"123", @"456", @"123", @"456", @"123", @"456", nil];
    self.locationArray = locationArray;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)locationButtonClicked:(id)sender {
    
    UIButton *btn=sender;
    DPSharePopView *view=[DPSharePopView initWithSuperView:btn menuCellNameArray:@[@"restaurant A",@"Flying Chaucer",@"Flying Noodle",@"Goldielox and Onion",@"Hot Dogma",@"Juice Knowledge",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",] imageNameArray:@[@"share_qq_friend",@"share_qq_kongjian",@"share_wx_friend",@"share_wx_pengyouquan",@"share_qq_friend",@"share_qq_kongjian",@"share_wx_friend",@"share_wx_pengyouquan",@"share_qq_friend",@"share_qq_kongjian",@"share_wx_friend",@"share_wx_pengyouquan",@"share_wx_pengyouquan",@"share_qq_friend",@"share_qq_kongjian",@"share_wx_friend",@"share_wx_pengyouquan"] cellDidClickBlock:^(NSInteger index) {
        
    }];
    
    [view show];
    
    
    /*
    chooseArray = [NSMutableArray arrayWithArray:@[@[@"超清",@"高清",@"标清",@"省流",@"自动"]]];
    
    //这个dropDownView是下拉菜单的点击视图  点击该视图可以显示下拉菜单
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(200,200, 60, 20) dataSource:self delegate:self];
    
    
    //因为不清楚显示下拉菜单的frame 但是我们可以借助一个视图将下拉菜单视图加载到我们想要放置的位置的视图上
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:superView];
    self.view.backgroundColor = [UIColor whiteColor];
    //下拉菜单添加到superView的frame上
    
    dropDownView.mSuperView = superView;
    
    [self.view addSubview:dropDownView];
     */
}

#pragma mark -- dropDownListDelegate
//码率切换请求方法
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%ld ,index:%ld",section,index);
    if (index == 0) {
        NSLog(@"切换超清");
    }
    if (index == 1) {
        NSLog(@"切换高清");
    }
    if (index == 2) {
        NSLog(@"切换标清");
    }
    if (index == 3) {
        NSLog(@"切换省流");
    }
    if (index == 4) {
        NSLog(@"切换自动");
    }
    _locationButton.titleLabel.text = chooseArray[section][index];
}


#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

- (void)setUpPostView {
    [self setUpBase];
    [self setUpTextView];
    [self setUpToolBar];
}

- (void)setUpToolBar
{
    GFAddToolBar *toolBar = [GFAddToolBar gf_toolbar];
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 监听键盘的弹出和隐藏
- (void)keyBoardWillChageFrame:(NSNotification *)note
{
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0,GFScreenHeight - keyBoadrFrame.origin.y);
    }];
    NSLog(@"KeyboardFrame.origin.y %f", keyBoadrFrame.origin.y);
    
}

#pragma mark - 准确布局
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _toolBar.gf_width = self.view.gf_width;
    _toolBar.gf_y = GFScreenHeight - _toolBar.gf_height - ZZNewNavH;
    
}

- (void)setUpTextView
{
    NSString *username = @"Alice Jin";
    GFPlaceholderTextView *textView = [[GFPlaceholderTextView alloc] init];
    textView.placeholder = [NSString stringWithFormat:@"What's in your mind, %@?",username];
    textView.frame = CGRectMake(0, ZZNewNavH, GFScreenWidth, GFScreenHeight - ZZNewNavH - GFTabBarH);
    //textView.backgroundColor = [UIColor yellowColor];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 退出当前界面
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 点击发表
 */
- (void)post
{
    GFBSLog(@"点击发表");
}

#pragma mark - 监听文字改变
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //发表点击判断
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

#pragma mark - 键盘弹出和退出
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先退出之前的键盘
    [self.view endEditing:YES];
    // 再叫出键盘
    [self.textView becomeFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}



@end
