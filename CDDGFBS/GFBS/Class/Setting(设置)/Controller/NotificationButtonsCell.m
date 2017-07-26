//
//  NotificationButtonsCell.m
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NotificationButtonsCell.h"

@interface NotificationButtonsCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;

@end

@implementation NotificationButtonsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequest:(ZZFriendRequestModel *)request {
    NSString *friendName = request.friendRequest.userUserName;
    _label.text = [NSString stringWithFormat:@"%@ sent you a friend request.", friendName];
    
}

@end
