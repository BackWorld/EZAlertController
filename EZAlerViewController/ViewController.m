//
//  ViewController.m
//  EZAlerViewController
//
//  Created by zhuxuhong on 2016/11/23.
//  Copyright © 2016年 zhuxuhong. All rights reserved.
//

#import "ViewController.h"
#import "EZAlertController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    EZAlertController *alert;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlert:(id)sender {
    [self showUIAlert:sender];
//    [self showEZAlert];
}

-(void)showUIAlert: (id)sender {
    UIAlertController *uialert = [UIAlertController alertControllerWithTitle:@"123" message:@"000" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"111" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"111" style:UIAlertActionStyleDestructive handler:nil];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"111" style:UIAlertActionStyleDefault handler:nil];
    UIPopoverPresentationController *pvc = uialert.popoverPresentationController;
    pvc.sourceView = sender;
    
    [uialert addAction:action1];
    [uialert addAction:action2];
    [uialert addAction:action3];

    [self presentViewController:uialert animated:true completion:nil];
}

-(void)showEZAlert{
    alert = [EZAlertController alertControllerWithTitle:@"title" message:@"message" owner:self preferredStyle:UIAlertControllerStyleAlert titleConfigurationHandler:^(EZAlertString *title) {
        title.font = [UIFont boldSystemFontOfSize:24];
        title.color = [UIColor redColor];
        title.alignment = NSTextAlignmentLeft;
    } messageConfigurationHandler:^(EZAlertString *message) {
        message.font = [UIFont boldSystemFontOfSize:16];
        message.color = [UIColor greenColor];
        message.alignment = NSTextAlignmentRight;
    }];
    alert.showRoundCorner = false;
    alert.showBlurEffect = false;
    alert.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [alert addActionWithTitle:@"action1" handler:^(UIAlertAction *action) {
        NSLog(@"%@",action.title);
    } configurationHandler:^(EZAlertAction *action) {
        action.titleAlignment = NSTextAlignmentLeft;
        action.titleColor = [UIColor orangeColor];
        action.iconImage = [UIImage imageNamed:@"icon"];
    }];
    [alert addActionWithTitle:@"action2" handler:^(UIAlertAction *action) {
        NSLog(@"%@",action.title);
    } configurationHandler:^(EZAlertAction *action) {
        action.titleAlignment = NSTextAlignmentRight;
        action.titleColor = [UIColor redColor];
    }];
    [alert addTextFieldWithConfigurationHandler:^(EZAlertTextField *textField) {
        textField.placeholder = @"用户名";
        textField.borderWidth = 1;
    }];
    [alert addTextFieldWithConfigurationHandler:^(EZAlertTextField *textField) {
        textField.placeholder = @"密码";
        textField.borderWidth = 2;
    }];
    [alert presentWithAnimated:true completion:nil];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
}

@end
