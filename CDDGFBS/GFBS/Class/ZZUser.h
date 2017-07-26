//
//  ZZUser.h
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFImage.h"
#import "ZZContentModel.h"

@class GFImage;
@class ZZContentModel;

@interface ZZUser : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUpdatedAt;
@property (nonatomic, copy) NSString *userUpdatedBy;
@property (nonatomic, copy) NSString *userCreatedAt;
@property (nonatomic, copy) NSString *usertName;
@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *usertPassword;
@property (nonatomic, copy) NSString *userUserName;
@property (nonatomic, copy) NSString *userStatus;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *userActivationKey;
@property (nonatomic, copy) NSString *userV;
@property (nonatomic, copy) NSString *userFacebookID;
@property (nonatomic, copy) NSString *userForgetPasswordKey;
@property (nonatomic, copy) NSString *userGoogleID;
@property (nonatomic, copy) NSString *userOrganizingLevel;
@property (nonatomic, copy) NSString *userOrganizingExp;
@property (nonatomic, retain) NSArray<NSString *> *userInterests;
@property (nonatomic, strong) GFImage *userProfileImage;
@property (nonatomic, strong) ZZContentModel *userLastCheckIn;

@property (nonatomic, assign) NSNumber *age;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) NSNumber *showOnLockScreen;
@property (nonatomic, assign) NSNumber *sounds;
@property (nonatomic, assign) NSNumber *emailNotification;
@property (nonatomic, assign) NSNumber *allowNotification;

@property (nonatomic, copy) UIImage *userProfileImage_UIImage;

+ (NSURLSessionDataTask *)login:(NSDictionary *)paramDic
                        Success:(void (^)(NSDictionary *result))success
                        Failure:(void (^)(NSError *error))failue;
@end
