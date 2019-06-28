//
//  TestPopupView.m
//  SNPopupViewController
//
//  Created by snlo on 2018/5/12.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "TestPopupView.h"

@implementation TestPopupView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	
	CABasicAnimation * sss = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	sss.duration = 0.15;
	sss.fromValue = @0.3;
	sss.toValue = @1;
	sss.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	sss.removedOnCompletion = NO;
	sss.fillMode = kCAFillModeForwards;
	
	self.showAnimation = sss;
	
    self.isBlankTouchInVisible = YES;
    
}

- (void)addSubviewShowAnimation {
	CABasicAnimation * sss = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	sss.duration = 0.15;
	sss.fromValue = @2;
	sss.toValue = @1;
	sss.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	sss.removedOnCompletion = NO;
	sss.fillMode = kCAFillModeForwards;
	
	[self.view1.layer addAnimation:sss forKey:nil];
	[self.view2.layer addAnimation:sss forKey:nil];
}
- (IBAction)handleButton:(id)sender {
	
	[self dismissFromSuperView:nil];
}


@end
