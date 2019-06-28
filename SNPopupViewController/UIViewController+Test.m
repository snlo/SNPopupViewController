//
//  UIViewController+Test.m
//  SNPopupViewController
//
//  Created by snlo on 2019/6/28.
//  Copyright © 2019 snlo. All rights reserved.
//

#import "UIViewController+Test.h"
#import <objc/runtime.h>

@interface UIViewController ()
//<UIGestureRecognizerDelegate>

@end

@implementation UIViewController (Test)

//void SNUIKitTool_replaceMethodFromNew(Class aClass, SEL aMethod, SEL newMethod) {
//    Method aMethods = class_getInstanceMethod(aClass, aMethod);
//    Method newMethods = class_getInstanceMethod(aClass, newMethod);
//
//    if(class_addMethod(aClass, aMethod, method_getImplementation(newMethods), method_getTypeEncoding(newMethods))) {
//        class_replaceMethod(aClass, newMethod, method_getImplementation(aMethods), method_getTypeEncoding(aMethods));
//    } else {
//        method_exchangeImplementations(aMethods, newMethods);
//    }
//}
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        SNUIKitTool_replaceMethodFromNew(self, @selector(viewWillAppear:), @selector(SNUIKit_viewWillAppear:));
//    });
//}
//
//- (void)SNUIKit_viewWillAppear:(BOOL)animated {
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
//    if ([self snuikit_navigationController].viewControllers.count < 2) {
//        self.sn_isAbleEdgeGesture = @(NO);
//    }
//    NSLog(@" ----2222-----------");
//    [self SNUIKit_viewWillAppear:animated];
//}
//
////解决多次触发navigation边缘返回手势后的冲突
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
////    return [self.sn_isAbleEdgeGesture boolValue]; //    <UIGestureRecognizerDelegate>
//    return YES;
//}
//
//- (void)setSn_isAbleEdgeGesture:(NSNumber *)sn_isAbleEdgeGesture {
//    objc_setAssociatedObject(self, @selector(sn_isAbleEdgeGesture), sn_isAbleEdgeGesture, OBJC_ASSOCIATION_RETAIN);
//}
//- (NSNumber *)sn_isAbleEdgeGesture {
//    NSNumber * number = objc_getAssociatedObject(self, _cmd);
//    if (!number) {
//        number = [NSNumber numberWithBool:YES];
//        objc_setAssociatedObject(self, @selector(sn_isAbleEdgeGesture), number, OBJC_ASSOCIATION_RETAIN);
//    }
//    return number;
//}
//
//- (UINavigationController *)snuikit_navigationController {
//    if (self.navigationController) {
//        return self.navigationController;
//    } else if (self.tabBarController.navigationController) {
//        return self.tabBarController.navigationController;
//    } else if ([self isKindOfClass:[UINavigationController class]]) {
//        return (UINavigationController *)self;
//    } else if ([self isKindOfClass:[UITabBarController class]]) {
//        if (((UITabBarController *)self).navigationController) {
//            return ((UITabBarController *)self).navigationController;
//        } else {
//            return [UINavigationController new];
//        }
//    } else {
//        return [UINavigationController new];
//    }
//}

@end
