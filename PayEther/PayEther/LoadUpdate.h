//
//  LoadUpdate.h
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadUpdate : NSObject <NSURLSessionDelegate>
-(void)Call_GetApi_with_parameter:(NSInteger)status Completetion:(void (^) (NSArray * result,NSError * error))completion;
-(void)Call_POSTApi_with_parameter:(NSInteger)status withData:(NSMutableString *)strData Completetion:(void (^) (NSArray *response,NSError * error))completion;
- (void)addTextFieldPadding:(UITextField *)textField withLeftPadding:(NSInteger)left;
-(void)saveDataToPlist:(NSString *)strPlistName withData:(NSDictionary *)dict;
-(NSMutableDictionary *)retrieveDataFromPlist:(NSString *)strPlistName;
-(void)deletePList;
@property (nonatomic,strong)NSString *strToken;
@end
