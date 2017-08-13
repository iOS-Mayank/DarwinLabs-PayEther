//
//  StatusBarNotification.h
//  IndianKitchen
//
//  Created by Sonitek Mac on 2016-11-22.
//  Copyright © 2016 Sonitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusBarNotification : NSObject
-(void)showNotification:(NSString *)message;
-(void)showErrorNotification:(NSString *)message;
@end
