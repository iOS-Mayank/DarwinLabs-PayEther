//
//  LogIn.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "LogIn.h"
#import "LoadUpdate.h"
#import "SVProgressHUD.h"
#import "StatusBarNotification.h"
#import "Home.h"

@interface LogIn (){
    LoadUpdate *loadUpdateObj;
    StatusBarNotification *statusBarObj;
}
@end

@implementation LogIn

- (void)viewDidLoad {
    [super viewDidLoad];
    loadUpdateObj=[[LoadUpdate alloc]init];
    statusBarObj=[[StatusBarNotification alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
   
    
    [loadUpdateObj addTextFieldPadding:self.txtUserName withLeftPadding:10];
    [loadUpdateObj addTextFieldPadding:self.txtPassword withLeftPadding:10];
    [self CustomizeTextField:self.txtUserName];
    [self CustomizeTextField:self.txtPassword];
    self.btnLogin.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnLogin.layer.borderWidth=0.6f;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"LoginState"]==1) {
      [self goToHome];
    }
}

-(void)CustomizeTextField:(UITextField *)myTextField
{
    CGRect rect = myTextField.bounds;
    rect.size.width=self.view.frame.size.width-52-55-1;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:UIRectCornerTopRight |UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(23.0, 23.0)];
    CAShapeLayer *layers = [CAShapeLayer layer];
    layers.frame = rect;
    layers.path = path.CGPath;
    myTextField.layer.mask = layers;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}

-(UITextField *)addCALayer:(UITextField *)textField{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, self.view.frame.size.width-16, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    return textField;
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.txtPassword){
        [self btnLoginClk:nil];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)btnLoginClk:(id)sender {
    NSLog(@"Login Button Clk ==>>");
    BOOL result= [self isFormDataValid];
    if (result==YES){
        NSMutableString *data = [NSMutableString stringWithFormat:@"email=%@&password=%@",[self.txtUserName.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[self.txtPassword.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        
        NSLog(@"Data Send is ==>>%@",data);
        [SVProgressHUD showWithStatus:@"Loading...."];
        [loadUpdateObj Call_POSTApi_with_parameter:2 withData:data Completetion:^(NSArray *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Final Data is ==>>%@",response);
                if(error)
                {
                    NSLog(@"Error finding Name1: %@",error);
                    [statusBarObj showErrorNotification:[error localizedDescription]];
                }
                else if (response){
                    self.txtUserName.text=self.txtPassword.text=@"";
                    [loadUpdateObj saveDataToPlist:@"userInfo.plist" withData:[response copy]];
                    [self goToHome];
                }
                else{
                    [statusBarObj showErrorNotification:@"Check UserName/Password again."];
                }
                [SVProgressHUD dismiss];
            });
        }];
    }
}

- (BOOL)isFormDataValid{
    UITextField *textField;
    NSString *alertMessage;
    BOOL result=YES;
    if (self.txtUserName.text.length<1)
    {
        textField=self.txtUserName;
        alertMessage=@"Please Enter UserName/Email";
        result=NO;
    }
    else if (![self NSStringIsValidEmail:self.txtUserName.text])
    {
        textField=self.txtUserName;
        alertMessage=@"Please Enter Valid UserName/Email";
        result=NO;
    }
    else if (self.txtPassword.text.length<1)
    {
        textField=self.txtPassword;
        alertMessage=@"Please Enter Password";
        result=NO;
    }
    if (result==NO)
    {
        [statusBarObj showErrorNotification:alertMessage];
        return result;
    }
    else
        return result;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    UIToolbar *RegToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
    }
    else{
        [RegToolbar setBarStyle:UIBarStyleBlackTranslucent];
    }
    [RegToolbar sizeToFit];
    RegToolbar.hidden = NO;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDone)];
    RegToolbar.items = [NSArray arrayWithObjects:flexibleSpace,doneButton,nil];
    textField.inputAccessoryView = RegToolbar;
    return YES;
}

-(void)btnDone{
    [self.view endEditing:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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

-(void)goToHome{
  //  UINavigationController *controller = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier: @"HomeView"];
    Home *homObj = (Home *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];    
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                         [self.navigationController pushViewController:homObj animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden=NO;
}
@end
