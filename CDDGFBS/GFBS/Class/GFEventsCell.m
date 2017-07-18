//
//  GFEventsCell.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

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

-(void)setEvent:(ZZContentModel *)event
{
    
    ZZContentModel *thisEvent = event;
    if ([thisEvent.listIsLike isEqualToString:@"true"]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
    }
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listImage.imageUrl] placeholderImage:nil];
    
    //[self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listImage.imageUrl] placeholderImage:nil];
    self.profileImageView.image = [UIImage imageNamed:@"profile-bg-green1_02.jpg"];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    self.bigTitleLabel.text = thisEvent.listEventRestaurant.restaurantName.en;
    
    self.placeLabel.text = thisEvent.listEventRestaurant.restaurantDistrict.informationName.en;
    
    self.smallTitleLabel.text = thisEvent.listPublishUser.userUserName;
    
    self.textField.text = thisEvent.listMessage;
    
    self.timeLabel.text = thisEvent.listEventCreatedAt;
    
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
