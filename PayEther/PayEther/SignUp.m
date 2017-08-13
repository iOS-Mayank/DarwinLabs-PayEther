//
//  SignUp.m
//  PayEther
//
//  Created by Mayank on 12/08/17.
//  Copyright © 2017 Darwin Labs. All rights reserved.
//

#import "SignUp.h"
#import "LoadUpdate.h"
#import "SVProgressHUD.h"
#import "StatusBarNotification.h"
#import "Home.h"

@interface SignUp (){
    LoadUpdate *loadUpdateObj;
    StatusBarNotification *statusBarObj;
}

@end

@implementation SignUp

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
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.txtFirstName=[self addCALayer:self.txtFirstName];
    self.txtEmail=[self addCALayer:self.txtEmail];
    self.txtPhoneNO=[self addCALayer:self.txtPhoneNO];
    self.txtPassword=[self addCALayer:self.txtPassword];
    self.txtConfirmPassword=[self addCALayer:self.txtConfirmPassword];
    [loadUpdateObj addTextFieldPadding:self.txtFirstName withLeftPadding:10];
    [loadUpdateObj addTextFieldPadding:self.txtEmail withLeftPadding:10];
    [loadUpdateObj addTextFieldPadding:self.txtPhoneNO withLeftPadding:10];
    [loadUpdateObj addTextFieldPadding:self.txtPassword withLeftPadding:10];
    [loadUpdateObj addTextFieldPadding:self.txtConfirmPassword withLeftPadding:10];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
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

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.txtConfirmPassword){
        [self btnSignUpClk:nil];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.txtPhoneNO) {
        // All digits entered
        if (range.location == 12) {
            return NO;
        }
        // Reject appending non-digit characters
        if (range.length == 0 && ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        // Auto-add hyphen before appending 4rd or 7th digit
        if (range.length == 0 && (range.location == 3 || range.location == 7)) {
            textField.text = [NSString stringWithFormat:@"%@ %@", textField.text, string];
            return NO;
        }
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 && (range.location == 4 || range.location == 8))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    [@[textField] enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
        [obj.layer setBorderWidth:0.0];
        [obj.layer setBorderColor:[UIColor whiteColor].CGColor];
    }];
    return YES;
}

- (BOOL)isFormDataValid{
    UITextField *textField;
    NSString *alertMessage;
    BOOL result=YES;
    if (self.txtFirstName.text.length<1)
    {
        textField=self.txtFirstName;
        alertMessage=@"Please Enter Your Name";
        result=NO;
    }
    else if (self.txtEmail.text.length<1)
    {
        textField=self.txtEmail;
        alertMessage=@"Please Enter Your Email";
        result=NO;
    }
    else if (![self NSStringIsValidEmail:self.txtEmail.text])
    {
        textField=self.txtEmail;
        alertMessage=@"Please Enter Valid Email";
        result=NO;
    }
    else if (self.txtPhoneNO.text.length<1)
    {
        textField=self.txtPhoneNO;
        alertMessage=@"Please Enter Your Phone No.";
        result=NO;
    }
    else if (self.txtPhoneNO.text.length<12)
    {
        textField=self.txtPhoneNO;
        alertMessage=@"Please Enter Valid Phone No.";
        result=NO;
    }
    else if (self.txtPassword.text.length<8)
    {
        textField=self.txtPassword;
        alertMessage=@"Please Enter Minimum 8 Character Password";
        result=NO;
    }
    else if (self.txtConfirmPassword.text.length<8)
    {
        textField=self.txtConfirmPassword;
        alertMessage=@"Please Enter Confirm Password";
        result=NO;
    }
    else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
    {
        textField=self.txtConfirmPassword;
        alertMessage=@"Pasword does not match";
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
                               }];
    [alert addAction:alertBtnOk];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnSignUpClk:(id)sender {
    NSLog(@"Sign Up Button Clk ==>>");
    BOOL result= [self isFormDataValid];
    
    if (result==YES){
         NSMutableString *data = [NSMutableString stringWithFormat:@"name=%@&password=%@&phone=%@&email=%@",[self.txtFirstName.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[self.txtPassword.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[self.txtPhoneNO.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]],[self.txtEmail.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

        NSLog(@"Data Send is ==>>%@",data);
        [SVProgressHUD showWithStatus:@"Loading...."];
        [loadUpdateObj Call_POSTApi_with_parameter:1 withData:data Completetion:^(NSArray *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Final Data is ==>>%@",response);
                if(error)
                {
                    NSLog(@"Error finding Name1: %@",error);
                    [statusBarObj showErrorNotification:[error localizedDescription]];
                }
                else if (response){
                    self.txtFirstName.text=self.txtEmail.text=self.txtPhoneNO.text=self.txtPassword.text=self.txtConfirmPassword.text=@"";
                      [loadUpdateObj saveDataToPlist:@"userInfo.plist" withData:[response copy]];
                    
                    Home *homObj = (Home *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
                    [UIView animateWithDuration:0.75
                                     animations:^{
                                         [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                                         [self.navigationController pushViewController:homObj animated:NO];
                                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                                     }];
                }
                else{
                    [statusBarObj showErrorNotification:@"No Data Found"];
                }
                [SVProgressHUD dismiss];
            });
        }];
    }
}

- (IBAction)btnCancelClk:(id)sender {
    NSLog(@"Cancel Button Clk ==>>");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHomeClk:(id)sender {
    NSLog(@"Home Button Clk ==>>");

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
