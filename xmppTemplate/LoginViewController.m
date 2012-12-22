//
//  LoginViewController.m
//  ios-xmppBase
//
//  Created by Anthony Perritano on 9/17/12.
//  Modified by Rachel Harsley 9/2012
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.jpeg"]];
    self.view.backgroundColor = background;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    //RACHEL MODIFIED
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kXMPPmyJID"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kXMPPmyPassword"];
    
    NSString *l = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyJID"];
    NSString *p = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyPassword"];
    
    if( l != nil ) {
        loginTextField.text = l;
    } else {
        loginTextField.text = @"@phenomena.evl.uic.edu";
    }
    
    if( p != nil ) {
        passTextField.text = p;
    } else {
         passTextField.text = @"password";
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        NSString *msg = [NSString stringWithFormat:@"setField method not nil and field: %@" ,field.text];
        [[self appDelegate] writeDebugMessage:msg];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:key]){
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}


- (IBAction)done:(id)sender
{
    NSString *msg = @"Done action triggered.";
    [[self appDelegate] writeDebugMessage:msg];
    
    [self setField:loginTextField forKey:@"kXMPPmyJID"]; //TODO don't do this until authenticated??
    [self setField:passTextField forKey:@"kXMPPmyPassword"];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[self appDelegate] setSuccessfullLogin:NO];
        [[self appDelegate] disconnect];
        [[self appDelegate] connect];
    }];
    
   // [[self appDelegate] showChooseFirstView:[[self appDelegate] getRootViewController]];
}

@end
