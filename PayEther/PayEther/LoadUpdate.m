//
//  LoadUpdate.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "LoadUpdate.h"
#import "SVProgressHUD.h"

@interface LoadUpdate(){
    
}
@end
@implementation LoadUpdate
@synthesize strToken;

//GET Method:
-(void)Call_GetApi_with_parameter:(NSInteger)status Completetion:(void (^)(NSArray *, NSError *))completion{
    
    NSURL *url;
    switch (status) {
        case 1:
            url=[NSURL URLWithString:@"http://139.59.27.120:8080/wallet/ethereum/"];
            break;
        case 2:
            url=[NSURL URLWithString:@"http://139.59.27.120:8080/wallet/ethereum/history/"];
            break;
        default:
            break;
    }
    
    // Creating a data task
    NSLog(@"Parsed Url is ==>>%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
   // [request setValue:@"" forHTTPHeaderField:@"Authorization"];
    [request setValue:strToken forHTTPHeaderField:@"x-access-token"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setAnimationRepeatCount:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"Loading...."];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse * _Nullable response, NSError *_Nullable error)
                                      {
                                          // Use the data here
                                          if(data == nil){
                                              completion(nil,error);
                                              return;
                                          }
                                          else{
                                              NSHTTPURLResponse *newResp = (NSHTTPURLResponse*)response;
                                              NSLog(@"%ld", (long)newResp.statusCode);
                                              NSMutableArray *parsedObject;
                                              if ([newResp statusCode] == 200 ) {
                    
                                                  parsedObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                  NSLog(@"Parsed Data ===>>>%@",parsedObject);
                                                  completion(parsedObject,error);
                                              }
                                              else{
                                                  completion(nil,error);
                                              }
                                          }
                                    }];
    // Starting the task
    [dataTask resume];
    
}
//POST Method:
-(void)Call_POSTApi_with_parameter:(NSInteger)status withData:(NSMutableString *)strData Completetion:(void (^) (NSArray *response,NSError * error))completion{
    NSString *urlString=[[NSString alloc]init];
    switch (status)
    {
        case 1:
        {
            urlString=@"http://139.59.27.120:8080/register/";
            break;
        }
        case 2:
        {
            urlString=@"http://139.59.27.120:8080/login/";
            break;
        }
        case 3:
        {
            urlString=@"http://139.59.27.120:8080/wallet/ethereum/create/";
            break;
        }
        case 4:
        {
            urlString=@"http://139.59.27.120:8080/wallet/ethereum/send/";
            break;
        }
        default:
            break;
    }
    NSData *jsonData = [strData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String is ==>>%@",myString);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    if (status==3||status==4) {
        [request setValue:strToken forHTTPHeaderField:@"x-access-token"];
    }
    else{
       [request setHTTPBody:jsonData];
    }
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"String is ==>>%@",string);
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setAnimationRepeatCount:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"Loading...."];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data == nil){
            completion(nil,error);
            return;
        }
        else{
            NSHTTPURLResponse *newResp = (NSHTTPURLResponse*)response;
            NSLog(@"%ld", (long)newResp.statusCode);
            NSMutableArray *parsedObject;
            if ([newResp statusCode] == 200 ) {
                parsedObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"Parsed Data ===>>>%@",parsedObject);
               // NSDictionary *dictResponse=[(NSHTTPURLResponse *)response allHeaderFields];
               // NSLog(@"Result==>>%@",dictResponse);
                completion(parsedObject,error);
            }
            else{
                completion(nil,error);
            }
        }
    }];
    [postDataTask resume];
}

- (void)addTextFieldPadding:(UITextField *)textField withLeftPadding:(NSInteger)left{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, left, 0)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)saveDataToPlist:(NSString *)strPlistName withData:(NSDictionary *)dict{
    NSLog(@"Save Data to Plist ==>>%@",dict);
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:strPlistName];
    NSLog(@"plist path is ==>>>%@",paths);
    NSError *error =nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if ([strPlistName isEqualToString:@"userInfo.plist"]) {
        if(plistData){
            [plistData writeToFile:plistPath atomically:YES];
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"LoginState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"LoginState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else{
        if(plistData){
            [plistData writeToFile:plistPath atomically:YES];
        }
    }
    
}

-(NSMutableDictionary *)retrieveDataFromPlist:(NSString *)strPlistName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:strPlistName];
    NSMutableDictionary *dictPlist = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSLog(@"Dict Detail is ==>>%@",dictPlist);
    return dictPlist;
}

-(void)deletePList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
    NSError *error = nil;
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]) {
        NSLog(@"File Name is ==>>%@",file);
        BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, file] error:&error];
        if (!success || error)
            NSLog(@"<== Error while deleting App PlistFiles ==>>");
        else
            NSLog(@"<== Successfully deleted App PlistFiles ==>>");
    }
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"LoginState"];

}

@end
