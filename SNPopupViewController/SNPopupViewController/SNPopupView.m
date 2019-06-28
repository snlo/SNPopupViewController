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
    
    if (!self.isOverrideAbleEdgeGesture) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        self.gesture_viewController = UIApplication.sharedApplication.keyWindow.rootViewController.childViewControllers.lastObject;
        
        if ([self.gesture_viewController respondsToSelector:NSSelectorFromString(@"SNPopupView_isAbleEdgeGesture")]) {
            
            self.isAbleEdgeGesture = [self.gesture_viewController performSelector:NSSelectorFromString(@"SNPopupView_isAbleEdgeGesture")];
            
            [self.gesture_viewController performSelector:NSSelectorFromString(@"setSNPopupView_isAbleEdgeGesture:") withObject:@(NO)];
#pragma clang diagnostic pop
        }
    }
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
	
    if (!self.isOverrideAbleEdgeGesture) {
        if (self.isAbleEdgeGesture) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.gesture_viewController performSelector:NSSelectorFromString(@"setSNPopupView_isAbleEdgeGesture:") withObject:@(YES)];
#pragma clang diagnostic pop
        }
    }
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

@interface UIViewController (SNPopupView) <UIGestureRecognizerDelegate>
@end
@implementation UIViewController (SNPopupView)

void SNPopupView_replaceMethodFromNew(Class aClass, SEL aMethod, SEL newMethod) {
    Method aMethods = class_getInstanceMethod(aClass, aMethod);
    Method newMethods = class_getInstanceMethod(aClass, newMethod);

    if(class_addMethod(aClass, aMethod, method_getImplementation(newMethods), method_getTypeEncoding(newMethods))) {
        class_replaceMethod(aClass, newMethod, method_getImplementation(aMethods), method_getTypeEncoding(aMethods));
    } else {
        method_exchangeImplementations(aMethods, newMethods);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SNPopupView_replaceMethodFromNew(self, @selector(viewWillAppear:), @selector(SNPopupView_viewWillAppear:));
    });
}

- (void)SNPopupView_viewWillAppear:(BOOL)animated {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if ([self SNPopupView_navigationController].viewControllers.count < 2) {
        self.SNPopupView_isAbleEdgeGesture = @(NO);
    }
    [self SNPopupView_viewWillAppear:animated];
}

//解决多次触发navigation边缘返回手势后的冲突
#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.SNPopupView_isAbleEdgeGesture boolValue];
}

- (void)setSNPopupView_isAbleEdgeGesture:(NSNumber *)SNPopupView_isAbleEdgeGesture {
    objc_setAssociatedObject(self, @selector(SNPopupView_isAbleEdgeGesture), SNPopupView_isAbleEdgeGesture, OBJC_ASSOCIATION_RETAIN);
}
- (NSNumber *)SNPopupView_isAbleEdgeGesture {
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = [NSNumber numberWithBool:YES];
        objc_setAssociatedObject(self, @selector(SNPopupView_isAbleEdgeGesture), number, OBJC_ASSOCIATION_RETAIN);
    }
    return number;
}

- (UINavigationController *)SNPopupView_navigationController {
    if (self.navigationController) {
        return self.navigationController;
    } else if (self.tabBarController.navigationController) {
        return self.tabBarController.navigationController;
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self;
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        if (((UITabBarController *)self).navigationController) {
            return ((UITabBarController *)self).navigationController;
        } else {
            return [UINavigationController new];
        }
    } else {
        return [UINavigationController new];
    }
}

@end
