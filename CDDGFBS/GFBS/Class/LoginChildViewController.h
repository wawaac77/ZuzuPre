//
//  LoginChildViewController.h
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn.h>

@interface LoginChildViewController : UIViewController

@property(strong, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end
