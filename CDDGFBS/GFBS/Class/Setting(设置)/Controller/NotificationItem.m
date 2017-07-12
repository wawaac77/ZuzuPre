//
//  NotificationItem.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NotificationItem.h"
#import <MJExtension.h>

@implementation NotificationItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"notificationText" : @"",
             @"notificationTime" : @"",
             @"checked" : @"",
            };
}
@end
