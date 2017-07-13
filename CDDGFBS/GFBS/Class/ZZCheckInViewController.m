//
//  ZZCheckInViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZCheckInViewController.h"
#import "DPSharePopView.h"

@interface ZZCheckInViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;

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
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBar];
    [self setUpTopView];
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
    DPSharePopView *view=[DPSharePopView initWithSuperView:btn menuCellNameArray:@[@"QQ好友",@"QQ空间",@"微信好友",@"微信朋友圈"] imageNameArray:@[@"share_qq_friend",@"share_qq_kongjian",@"share_wx_friend",@"share_wx_pengyouquan"] cellDidClickBlock:^(NSInteger index) {
        
    }];
    [view show];
    _locationButton.titleLabel.text =
}
@end
