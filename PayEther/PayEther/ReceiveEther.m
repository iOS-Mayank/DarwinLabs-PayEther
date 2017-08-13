//
//  ReceiveEther.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "ReceiveEther.h"
#import "LoadUpdate.h"
#import "SVProgressHUD.h"
#import "StatusBarNotification.h"

@interface ReceiveEther (){
    LoadUpdate *loadUpdateObj;
    StatusBarNotification *statusBarObj;
}

@end

@implementation ReceiveEther

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loadUpdateObj=[[LoadUpdate alloc]init];
    statusBarObj=[[StatusBarNotification alloc]init];
    NSMutableDictionary *userDict=[loadUpdateObj retrieveDataFromPlist:@"userInfo.plist"];
    [SVProgressHUD showWithStatus:@"Loading...."];
    loadUpdateObj.strToken=[userDict valueForKey:@"token"];
    [loadUpdateObj Call_GetApi_with_parameter:1 Completetion:^(NSArray *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Final Data is ==>>%@",result);
            if(error)
            {
                NSLog(@"Error finding Name1: %@",error);
                [statusBarObj showErrorNotification:[error localizedDescription]];
            }
            else if (result){
                self.etherAddress.text=[[result valueForKey:@"account"] valueForKey:@"xpub"];
            }
            else{
                [statusBarObj showErrorNotification:@"No Data Found"];
            }
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
