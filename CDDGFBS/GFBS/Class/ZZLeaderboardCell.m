//
//  ZZLeaderboardCell.m
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZLeaderboardCell.h"
#import "ZZLeaderboardModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ZZLeaderboardCell ()


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;


@end

@implementation ZZLeaderboardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _numberLabel.font = [UIFont boldSystemFontOfSize:18];
        _numberLabel.textColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
    }
    else {
        _numberLabel.textColor = [UIColor blackColor];
    }

}

- (void)setUser:(ZZLeaderboardModel *)user {
    ZZLeaderboardModel *thisUser = user;
    _numberLabel.text = [NSString stringWithFormat:@"%@", thisUser.leaderboardRank];
    //[self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisUser.leaderboardMember.userProfileImage.imageUrl] placeholderImage:nil];
    //_profileImageView.image = [UIImage imageNamed:@"icon.png"];
    [self downloadImageFromURL:thisUser.leaderboardMember.userProfileImage.imageUrl];
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _usernameLabel.text = thisUser.leaderboardMember.userUserName;
    _locationLabel.text = thisUser.leaderboardMember.userEmail;
    _scoreLabel.text = [NSString stringWithFormat:@"%@",thisUser.leaderboardLevel];
}

-(void) downloadImageFromURL :(NSString *)imageUrl{
    
    
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSLog(@"url %@", url);
    NSLog(@"urlData %@", urlData);
    
    if ( urlData )
        
    {
        
        NSLog(@"Downloading started...");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
        
        NSLog(@"FILE : %@",filePath);
        
        [urlData writeToFile:filePath atomically:YES];
        
        UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
        
        self.profileImageView.image=image1;
        
        NSLog(@"Completed...");
        
    }
}


@end
