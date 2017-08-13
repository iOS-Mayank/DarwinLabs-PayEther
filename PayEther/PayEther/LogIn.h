//
//  LogIn.h
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogIn : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
//@property (strong, nonatomic) IBOutlet UIButton *btnSlideOut;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@end
