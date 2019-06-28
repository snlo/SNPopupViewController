//
//  ViewController.m
//  SNPopupViewController
//
//  Created by sunDong on 2017/2/22.
//  Copyright © 2017年 snlo. All rights reserved.
//

#import "ViewController.h"

#import "TestPopupView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//	pod trunk push SNPopupViewController.podspec --verbose --allow-warnings --use-libraries
	
	UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.frame = CGRectMake(60, 200, 60, 60);
	[button setTitle:@"show" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
}

- (void)handleButton:(UIButton *)sender {
    
	TestPopupView * vc = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TestPopupView class]) owner:nil options:nil] lastObject];
	
    [vc showInSuperView:nil];
//    [vc showin:^{
//
//    } withViewController:self.navigationController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissFromSuperView:nil];
    });
	
}
- (IBAction)handleBack:(UIButton *)sender {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
