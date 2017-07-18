//
//  ZZContentModel.h
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "EventRestaurant.h"
#import "GFImage.h"

@class ZZUser;
@class EventRestaurant;
@class GFImage;

typedef NS_ENUM(NSInteger , MyPublishContentType){
    
    AllPublishContent = 0,
    
    FriendsPublishContent = 1,

    MePublishContent = 2,
    
};

@interface ZZContentModel : NSObject

@property (nonatomic, copy) NSString *listEventID;
@property (nonatomic, copy) NSString *listEventUpdatedBy;
@property (nonatomic, copy) NSString *listEventUpdatedAt;
@property (nonatomic, copy) NSString *listEventCreatedBy;
@property (nonatomic, copy) NSString *listEventCreatedAt;
@property (nonatomic, copy) NSString *listMessage;
@property (nonatomic, strong) ZZUser *listPublishUser;
@property (nonatomic, strong) EventRestaurant *listEventRestaurant;
@property (nonatomic, strong) GFImage *listImage;
@property (nonatomic, copy) NSString *listIsLike;

@end
