//
//  GFEventsCell.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GFEventsCell.h"

#import "ZZContentModel.h"
#import "GFImage.h"

#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface GFEventsCell()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (strong, nonatomic) ZZContentModel *thisEvent;
@property (strong , nonatomic) GFHTTPSessionManager *manager;

/*图片View*/
//@property (weak ,nonatomic) GFTopicPictureView *pictureView;
/*声音View*/
//@property (weak ,nonatomic) GFTopicVoiceView *voiceView;
/*视频View*/
//@property (weak ,nonatomic) GFTopicVideoView *videoView;


@end

@implementation GFEventsCell

/*
#pragma mark - 懒加载
-(GFTopicPictureView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [GFTopicPictureView gf_viewFromXib];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

-(GFTopicVideoView *)videoView
{
    if (!_videoView) {
        _videoView = [GFTopicVideoView gf_viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

-(GFTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        _voiceView = [GFTopicVoiceView gf_viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}
*/

-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

-(void)setEvent:(ZZContentModel *)event
{
    
    ZZContentModel *thisEvent = event;
    self.thisEvent = thisEvent;
    if ([thisEvent.listIsLike isEqualToNumber:@1]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
    }
    
    [_heartButton addTarget:self action:@selector(likedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listImage.imageUrl] placeholderImage:nil];
    NSLog(@"thisEvent.listImage.imageUrl %@", thisEvent.listImage.imageUrl);
    //[self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listImage.imageUrl] placeholderImage:nil];
    //self.profileImageView.image = [UIImage imageNamed:@"profile-bg-green1_02.jpg"];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listPublishUser.userProfileImage.imageUrl] placeholderImage:nil];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    self.bigTitleLabel.text = thisEvent.listEventRestaurant.restaurantName.en;
    
    self.placeLabel.text = thisEvent.listEventRestaurant.restaurantDistrict.informationName.en;
    
    self.smallTitleLabel.text = thisEvent.listPublishUser.userUserName;
    
    self.textField.text = thisEvent.listMessage;
    
    self.timeLabel.text = thisEvent.listEventCreatedAt;
    
}

- (void)likedButtonClicked: (UIButton *) sender {
    NSLog(@"self.thisEvent.listIsLike %@", self.thisEvent.listIsLike);
   
    if ([self.thisEvent.listIsLike isEqualToNumber:@1]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
        self.thisEvent.listIsLike = [NSNumber numberWithBool:false];
        [self likeCheckin:false];
        
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
        self.thisEvent.listIsLike = [NSNumber numberWithBool:true];
        [self likeCheckin:true];
    }
}

- (void)likeCheckin: (BOOL) like {
    NSLog(@"_event %@", self.thisEvent);
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSNumber *likeNum = [[NSNumber alloc] initWithBool:like];
    NSLog(@"likeNum %@", likeNum);
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    //NSLog(@"user token %@", userToken);
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    NSString *checkinId = [[NSString alloc] initWithFormat:@"%@", self.thisEvent.listEventID];
    //NSString *checkinId = _event.listEventID;
    NSLog(@"checkinId %@", checkinId);
    NSDictionary *inSubData = @{@"checkinId" : checkinId, @"isLike" : likeNum};
    inData = @{@"action" : @"likeCheckin", @"token" : userToken, @"data" : inSubData};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
