//
//  Home.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "Home.h"
#import "LoadUpdate.h"
#import "SVProgressHUD.h"
#import "StatusBarNotification.h"

@interface Home (){
    LoadUpdate *loadUpdateObj;
    StatusBarNotification *statusBarObj;
    NSMutableDictionary *userDict;
}

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loadUpdateObj=[[LoadUpdate alloc]init];
    statusBarObj=[[StatusBarNotification alloc]init];
    userDict=[loadUpdateObj retrieveDataFromPlist:@"userInfo.plist"];
    NSLog(@"Dict Data is ==>>%@",userDict);
    [self btnBalnaceClk:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (IBAction)btnCreateWallet:(id)sender {
    NSLog(@"Create Wallet Button Clicked ==>>");
    [SVProgressHUD showWithStatus:@"Loading...."];
    loadUpdateObj.strToken=[userDict valueForKey:@"token"];
    
    [loadUpdateObj Call_POSTApi_with_parameter:3 withData:nil Completetion:^(NSArray *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Final Data is ==>>%@",response);
            if(error)
            {
                NSLog(@"Error finding Name1: %@",error);
                [statusBarObj showErrorNotification:[error localizedDescription]];
            }
            else if (response){
                [self showAlert_withCode:1 withMessage:[NSString stringWithFormat:@"1. ID= %@\n2. Created at= %@\n3. Updated at= %@\n4. User= %@\n5. Xpub= %@\n6. Balanec= %@",[[response valueForKey:@"account"] valueForKey:@"_id"],[[response valueForKey:@"account"] valueForKey:@"createdAt"],[[response valueForKey:@"account"] valueForKey:@"updatedAt"],[[response valueForKey:@"account"] valueForKey:@"user"],[[response valueForKey:@"account"] valueForKey:@"xpub"],[response valueForKey:@"balance"]]];
            }
            else{
                [statusBarObj showErrorNotification:@"Either wallet already created."];
            }
            [SVProgressHUD dismiss];
        });
    }];
}
- (void)showAlert_withCode:(NSInteger)Code withMessage:(NSString *)message{
    NSString *title;
    if (Code==1)
        title=@"Success";
    else
        title=@"Alert";
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertBtnOk=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:alertBtnOk];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBalnaceClk:(id)sender {
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
                [self showAlert_withCode:1 withMessage:[NSString stringWithFormat:@"1. ID= %@\n2. Created at= %@\n3. Updated at= %@\n4. User= %@\n5. Xpub= %@\n6. Balanec= %@",[[result valueForKey:@"account"] valueForKey:@"_id"],[[result valueForKey:@"account"] valueForKey:@"createdAt"],[[result valueForKey:@"account"] valueForKey:@"updatedAt"],[[result valueForKey:@"account"] valueForKey:@"user"],[[result valueForKey:@"account"] valueForKey:@"xpub"],[result valueForKey:@"balance"]]];
            }
            else{
                [statusBarObj showErrorNotification:@"No Data Found"];
            }
            [SVProgressHUD dismiss];
        });
    }];
}

- (IBAction)getTransactionHistory:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading...."];
    loadUpdateObj.strToken=[userDict valueForKey:@"token"];
    [loadUpdateObj Call_GetApi_with_parameter:2 Completetion:^(NSArray *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Final Data is ==>>%@",result);
            if(error)
            {
                NSLog(@"Error finding Name1: %@",error);
                [statusBarObj showErrorNotification:[error localizedDescription]];
            }
            else if (result){
                [self showAlert_withCode:1 withMessage:[NSString stringWithFormat:@"1.Message= %@\n2. result= %@\n3. Satus=%@",[result valueForKey:@"message"],[result valueForKey:@"result"],[result valueForKey:@"status"]]];
            }
            else{
                [statusBarObj showErrorNotification:@"No Data Found"];
            }
            [SVProgressHUD dismiss];
        });
    }];
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
