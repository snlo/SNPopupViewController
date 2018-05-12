//
//  ViewController.m
//  SNPopupViewController
//
//  Created by sunDong on 2017/2/22.
//  Copyright © 2017年 snlo. All rights reserved.
//

#import "ViewController.h"

#import "TestCVIEW.h"
#import <SNUIKit.h>
#import <SNTool.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	

	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//	pod trunk push SNPopupViewController.podspec --verbose --allow-warnings --use-libraries
	
	UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.frame = CGRectMake(60, 200, 60, 60);
	[button setTitle:SNString_localized(@"测试") forState:UIControlStateNormal];
	[button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
}

- (void)handleButton:(UIButton *)sender {
	
	TestCVIEW * vc = [TestCVIEW sn_viewWithNib];
	
	[vc showInSuperView:nil];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
