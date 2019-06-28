//
//  SNPopupView.m
//  AiteCube
//
//  Created by snlo on 2017/12/7.
//  Copyright © 2017年 AiteCube. All rights reserved.
//

#import "SNPopupView.h"
#import <objc/runtime.h>

typedef void(^ReceiveDismissBlock)(void);

@interface SNPopupView () <UIGestureRecognizerDelegate>

@property (nonatomic, copy) ReceiveDismissBlock receiveDismissBlock;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, strong) UIViewController * gesture_viewController; //标记边缘返回手势
@property (nonatomic, assign) BOOL isAbleEdgeGesture;

@end

@implementation SNPopupView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark -- <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //防止自视图触发点击回退事件
	__block BOOL gesture = true;
	[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([touch.view isDescendantOfView:obj]) {
			gesture = false;
		}
	}];
    return gesture;
}

#pragma mark -- event response
- (void)touchesBlank:(UITapGestureRecognizer *)sender {
    if (!self.isBlankTouchInVisible) {
        [self dismissFromSuperView:nil];
    }
}

#pragma mark -- public methods
- (void)addSubviewShowAnimation {
	[self.subviews.firstObject.layer addAnimation:self.showAnimation forKey:nil];
}

- (void)showin:(void(^)(void))block withViewController:(UIViewController *)viewController {
	self.viewController = viewController;
	[self showInSuperView:block];
}
- (void)showInSuperView:(void(^)(void))block {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    //加载单击回退手势
    UITapGestureRecognizer * touchBlankGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBlank:)];
    touchBlankGesture.numberOfTapsRequired = 1;
    touchBlankGesture.delegate = self;
    [self addGestureRecognizer:touchBlankGesture];
    
    //入场动画
	[self addSubviewShowAnimation];
    
    self.alpha = 0;
    
    [UIApplication.sharedApplication.keyWindow endEditing:YES];
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

- (void)addSubviewDismissAnimation {
	[self.subviews.firstObject.layer addAnimation:self.dismissAnimation forKey:nil];
}
- (void)dismissFromSuperView:(void(^)(void))block {
	//退场动画
	[self addSubviewDismissAnimation];
	
	self.alpha = 1;
	[UIView animateWithDuration:0.15 animations:^{
		self.alpha = 0;
		
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		if (block) {
			block();
		}
		if (self.receiveDismissBlock) {
			self.receiveDismissBlock();
		}
	}];
}

- (void)receiveDismissBlock:(void(^)(void))block {
    if (block) {
        self.receiveDismissBlock = block;
    }
}
#pragma mark -- private methods

#pragma mark -- getter / setter
@synthesize showAnimation = _showAnimation;
- (void)setShowAnimation:(CABasicAnimation *)showAnimation {
	_showAnimation = showAnimation;
}
@synthesize dismissAnimation = _dismissAnimation;
- (void)setDismissAnimation:(CABasicAnimation *)dismissAnimation {
	_dismissAnimation = dismissAnimation;
}

- (CABasicAnimation *)showAnimation {
	if (!_showAnimation) {
		_showAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		_showAnimation.duration = 0.15;
		_showAnimation.fromValue = @1.2;
		_showAnimation.toValue = @1;
		_showAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
		_showAnimation.removedOnCompletion = NO;
		_showAnimation.fillMode = kCAFillModeForwards;
	} return _showAnimation;
}
- (CABasicAnimation *)dismissAnimation {
	if (_dismissAnimation) {
		_dismissAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		_dismissAnimation.duration = 3.0;
		_dismissAnimation.toValue = @0;
		_dismissAnimation.removedOnCompletion = NO;
		_dismissAnimation.fillMode = kCAFillModeForwards;
	} return _dismissAnimation;
}

@end
