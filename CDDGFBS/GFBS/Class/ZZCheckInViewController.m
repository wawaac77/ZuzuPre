//
//  ZZCheckInViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZCheckInViewController.h"
#import "DPSharePopView.h"
#import "DropDownListView.h"
//#import "GFAddToolBar.h"
#import "GFPlaceholderTextView.h"
//#import "AddLLImagePickerVC.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ZZCheckInViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *chooseArray;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *toolBarView;

@property (weak, nonatomic) IBOutlet UIButton *imagePickerButton;
- (IBAction)imagePickerButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
- (IBAction)checkinButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)facebookButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
- (IBAction)twitterButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pickerImageView;

@property (nonatomic, weak) UIImageView *imageView;

@property (weak, nonatomic) UIImage *pickedImage;

/** 文本输入控件 */
@property (nonatomic, weak) GFPlaceholderTextView *textView;
//@property (nonatomic, weak) GFAddToolBar *toolBar;

@property (weak, nonatomic) NSMutableArray *locationArray;
//@property (strong, nonatomic) NSArray<LLImagePickerModel *> *pickedImagesArray;

@property (strong, nonatomic) GFHTTPSessionManager *manager;

@end

@implementation ZZCheckInViewController

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
    [self loadNewData];
    
    [self setUpTopView];
    [self setUpPostView];
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
    [self setUpNavBar];
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
    [self setUpToolBarView];
    [self setUpImageView];
    //[self setUpToolBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUpToolBarView {
    self.toolBarView.frame = CGRectMake(0, GFScreenHeight - GFTabBarH - 80, GFScreenWidth, 80);
    //通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUpImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, GFScreenHeight - GFTabBarH - 80 - 120, GFScreenWidth, 120)];
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

/*
- (void)setUpToolBar
{
    GFAddToolBar *toolBar = [GFAddToolBar gf_toolbar];
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
 */


#pragma mark - 准确布局
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //_toolBar.gf_width = self.view.gf_width;
    //_toolBar.gf_y = GFScreenHeight - _toolBar.gf_height - ZZNewNavH;
    
}

- (void)setUpTextView
{
    NSString *username = @"Alice Jin";
    GFPlaceholderTextView *textView = [[GFPlaceholderTextView alloc] init];
    textView.placeholder = [NSString stringWithFormat:@"What's in your mind, %@?",username];
    textView.frame = CGRectMake(0, ZZNewNavH, GFScreenWidth, GFScreenHeight - ZZNewNavH - GFTabBarH - 80);
    //textView.backgroundColor = [UIColor yellowColor];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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

/*
#pragma mark - 键盘弹出和退出
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先退出之前的键盘
    [self.view endEditing:YES];
    // 再叫出键盘
    [self.textView becomeFirstResponder];
}
 */

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


#pragma - imagePicker action
- (IBAction)imagePickerButtonClicked:(id)sender {
    
    /*
    AddLLImagePickerVC *imagePickerVC = [[AddLLImagePickerVC alloc] init];
    //imagePickerVC.view.frame = [UIScreen mainScreen].bounds;
    
    [self.navigationController pushViewController:imagePickerVC animated:YES];
    NSLog(@" %@", imagePickerVC.pickedImageArray);
    _pickedImagesArray = imagePickerVC.pickedImageArray;
     */
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    self.pickedImage = chosenImage;
    NSLog(@"chosenImage %@", chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)cancelButtonClicked:(id)sender {
    NSLog(@"Cancel Button clicked");
    self.textView.text = nil;
}

- (IBAction)twitterButtonClicked:(id)sender {
}

- (IBAction)facebookButtonClicked:(id)sender {
}

- (IBAction)checkinButtonClicked:(id)sender {
    NSLog(@"check in button clicked");
    if (![self.textView.text isEqualToString:@""]) {
        NSLog(@"Check in posted");
        [self postCheckIn];
        self.textView.text = nil;
    }
}

- (void)postCheckIn {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"userToken in checkinVC %@", userToken);
    NSString *restaurantId = @"58d7fd7f75fe8a7b025fe7ff";
    //NSString *imageBase64 = [self encodeToBase64String:_pickedImage];
    NSString *imageBase64 = [UIImagePNGRepresentation(_pickedImage)
     base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *imageData = UIImagePNGRepresentation(_pickedImage);
    NSString *imageType = [self contentTypeForImageData:imageData];
    NSString *imageInfo = [NSString stringWithFormat:@"data:%@;base64,%@",imageType, imageBase64];
    
    //NSString *imageInfo = @"";
    NSLog(@"data:image/jpeg;base64,%@", imageBase64);
    
    //NSString *imageInfo = @"data:image/jpeg;base64,%@", imageBase64;

    
    NSDictionary *inSubData = @{@"restaurantId" : restaurantId,
                                @"message" : self.textView.text,
                                @"image": imageInfo}; //what of image?
    
    NSDictionary *inData = @{@"action" : @"checkin",
                             @"token" : userToken,
                             @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ZUZU" message:@"Check in successful!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];

        //[self textView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            break;
        case 0x42:
            return @"image/bmp";
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - 监听键盘的弹出和隐藏
- (void)keyBoardWillChageFrame:(NSNotification *)note
{
    NSLog(@"keyboard changed");
    
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        NSLog(@"toolBarView.y before %f", self.toolBarView.gf_y);
        NSLog(@"checkin button before %f", self.checkinButton.gf_y);
        NSLog(@"keyboardframe before %f", keyBoadrFrame.origin.y);
        self.toolBarView.transform = CGAffineTransformMakeTranslation(0,keyBoadrFrame.origin.y - GFScreenHeight);
        NSLog(@"toolBarView.y after %f", self.toolBarView.gf_y);
        NSLog(@"checkin button after %f", self.checkinButton.gf_y);
        NSLog(@"keyboardframe after %f", keyBoadrFrame.origin.y);
    }];
    
}


@end
