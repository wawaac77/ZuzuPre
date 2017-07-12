//
//  ZZUser.h
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (NSURLSessionDataTask *)login:(NSDictionary *)paramDic
                        Success:(void (^)(NSDictionary *result))success
                        Failure:(void (^)(NSError *error))failue;
@end
