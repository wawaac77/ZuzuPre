//
//  NotificationCell.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NotificationCell.h"
#import "NotificationItem.h"

@interface NotificationCell()

@property (weak, nonatomic) IBOutlet UIView *checkedSignView;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation NotificationCell


-(void)setNotification:(NotificationItem *)notification
{
    NotificationItem *thisNotification = notification;
    //[self downloadImageFromURL:thisEvent.eventImage.imageUrl];
    self.bigLabel.text = thisNotification.notificationText;
    self.timeLabel.text = thisNotification.updatedAt;
    if ([thisNotification.isRead isEqualToNumber: @1]) {
        self.checkedSignView.backgroundColor = [UIColor darkGrayColor];
    } else {
        self.checkedSignView.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
        self.bigLabel.textColor = [UIColor blackColor];
        self.bigLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    
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
