//
//  ViewController.m
//  SNPopupViewController
//
//  Created by sunDong on 2017/2/22.
//  Copyright © 2017年 snlo. All rights reserved.
//

#import "ViewController.h"

#import "TestCVIEW.h"

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
	[button setTitle:@"ddd" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
}

- (void)handleButton:(UIButton *)sender {
	
	TestCVIEW * vc = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TestCVIEW class]) owner:nil options:nil] lastObject];
	
	[vc showInSuperView:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissFromSuperView:nil];
    });
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
