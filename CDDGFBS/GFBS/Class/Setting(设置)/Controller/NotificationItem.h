//
//  NotificationItem.h
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationItem : NSObject

@property (nonatomic, copy) NSString *notificationText;
@property (nonatomic, copy) NSString *notificationTime;
@property (nonatomic, assign) NSString *checked;

@end
