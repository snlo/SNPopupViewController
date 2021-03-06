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
@property (nonatomic, assign) BOOL isAbleEdgeGesture;

@end

@implementation SNPopupView

+ (instancetype)viewWithNib {
    SNPopupView * view = [[SNPopupView alloc] init];
    if ([NSStringFromClass([self class]) isEqualToString:@"SNPopupView"]) {
        return view;
    }
    view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

#pragma mark -- <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	__block BOOL gesture = true;
	[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([touch.view isDescendantOfView:obj]) gesture = false; //防止附加视图触发点击回退事件
	}];
    return gesture;
}

#pragma mark -- event response
- (void)touchesBlank:(UITapGestureRecognizer *)sender {
    if (!self.isBlankTouchInVisible) [self dismiss:nil];
}

#pragma mark -- public methods
- (void)addSubviewShowAnimation {
	[self.subviews.firstObject.layer addAnimation:self.showAnimation forKey:nil];
}

- (void)addSubviewDismissAnimation {
    [self.subviews.firstObject.layer addAnimation:self.dismissAnimation forKey:nil];
}

- (void)show:(void(^)(void))block in:(UIViewController *)viewController {
	self.viewController = viewController;
	[self show:block];
}

- (void)show:(void(^)(void))block {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UITapGestureRecognizer * touchBlankGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBlank:)]; //单击回退
    touchBlankGesture.numberOfTapsRequired = 1;
    touchBlankGesture.delegate = self;
    [self addGestureRecognizer:touchBlankGesture];
    
	[self addSubviewShowAnimation];
    
    [UIApplication.sharedApplication.keyWindow endEditing:YES];
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (block) block();
    }];
}

- (void)dismiss:(void(^)(void))block {
	[self addSubviewDismissAnimation];
	
	self.alpha = 1;
	[UIView animateWithDuration:0.15 animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		if (block) block();
		if (self.receiveDismissBlock) self.receiveDismissBlock();
	}];
}

- (void)receiveDismissed:(void(^)(void))block {
    if (block) self.receiveDismissBlock = block;
}

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
