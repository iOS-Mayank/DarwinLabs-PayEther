//
//  SendEther.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "SendEther.h"
#import "SVProgressHUD.h"
#import "StatusBarNotification.h"
#import "LoadUpdate.h"

@interface SendEther (){
    LoadUpdate *loadUpdateObj;
    StatusBarNotification *statusBarObj;
    NSMutableDictionary *userDict;
}

@end

@implementation SendEther

- (void)viewDidLoad {
    [super viewDidLoad];
    loadUpdateObj=[[LoadUpdate alloc]init];
    statusBarObj=[[StatusBarNotification alloc]init];
    // Do any additional setup after loading the view.
}
- (IBAction)btnSend:(id)sender {
    NSLog(@"Send Button Click ==>>");
    userDict=[loadUpdateObj retrieveDataFromPlist:@"userInfo.plist"];
    NSLog(@"Dict Data is ==>>%@",userDict);
    
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
                NSMutableString *data = [NSMutableString stringWithFormat:@"to=%@&amount=0.01",[self.txtSend.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
                [self sendData:data];
            }
            else{
                [statusBarObj showErrorNotification:@"No Data Found"];
            }
            [SVProgressHUD dismiss];
        });
    }];
}

-(void)sendData:(NSMutableString *)data{
    [SVProgressHUD showWithStatus:@"Loading...."];
    loadUpdateObj.strToken=[userDict valueForKey:@"token"];
    [loadUpdateObj Call_POSTApi_with_parameter:4 withData:data Completetion:^(NSArray *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Final Data is ==>>%@",response);
            if(error)
            {
                NSLog(@"Error finding Name1: %@",error);
                [statusBarObj showErrorNotification:[error localizedDescription]];
            }
            else if (response){
            }
            else{
                [statusBarObj showErrorNotification:@"Insufficient Funds To Transfer"];
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
