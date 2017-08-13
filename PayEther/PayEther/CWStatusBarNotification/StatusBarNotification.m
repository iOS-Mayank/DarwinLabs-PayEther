//
//  StatusBarNotification.m
//  IndianKitchen
//
//  Created by Sonitek Mac on 2016-11-22.
//  Copyright © 2016 Sonitech. All rights reserved.
//

#import "StatusBarNotification.h"
#import "CWStatusBarNotification.h"

@interface StatusBarNotification ()
@property (strong, nonatomic) CWStatusBarNotification *notification;
@end

@implementation StatusBarNotification

-(void)showNotification:(NSString *)message{
    
    if (!self.notification) {
        // initialize CWNotification
        self.notification = [CWStatusBarNotification new];
        
        // set default blue color (since iOS 7.1, default window tintColor is black)
     //   self.notification.notificationLabelBackgroundColor = [[MySingleton sharedMySingleton]getStatusBarNotificationColor];
        
        self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        self.notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
//        self.notification.notificationStyle = self.notificationStyle.selectedSegmentIndex == 0 ?
//        CWNotificationStyleStatusBarNotification : CWNotificationStyleNavigationBarNotification;
        self.notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        self.notification.notificationLabelFont=[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:18.0f];
       // self.notification.notificationLabelTextColor=[[MySingleton sharedMySingleton]getStatusBarTextColor];
        self.notification.notificationLabel.adjustsFontSizeToFitWidth=YES;
    }
    [self.notification displayNotificationWithMessage:message forDuration:1.0];
}

-(void)showErrorNotification:(NSString *)message{
    if (!self.notification) {
        // initialize CWNotification
        self.notification = [CWStatusBarNotification new];
        
        // set default blue color (since iOS 7.1, default window tintColor is black)
       // self.notification.notificationLabelBackgroundColor = [[MySingleton sharedMySingleton]getStatusBarNotificationColor];
        self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        self.notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        //        self.notification.notificationStyle = self.notificationStyle.selectedSegmentIndex == 0 ?
        //        CWNotificationStyleStatusBarNotification : CWNotificationStyleNavigationBarNotification;
        self.notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        self.notification.notificationLabelFont=[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:18.0f];
       // self.notification.notificationLabelTextColor=[[MySingleton sharedMySingleton]getStatusBarTextColor];
        self.notification.notificationLabel.adjustsFontSizeToFitWidth=YES;
    }
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"notify_error.png"];
    CGFloat offsetY = -15.0;
    attachment.bounds = CGRectMake(-10, offsetY, 40, 40);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@""];
    [myString appendAttributedString:attachmentString];
    NSMutableAttributedString *myString1= [[NSMutableAttributedString alloc] initWithString:message];
    [myString appendAttributedString:myString1];
    [self.notification displayNotificationWithAttributedString:myString forDuration:1.0];
}
@end
