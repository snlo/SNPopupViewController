//
//  SNPopupView.h
//  AiteCube
//
//  Created by snlo on 2017/12/7.
//  Copyright © 2017年 AiteCube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNPopupView : UIView

/**
 是否不能点击空白处回退，默认为'NO'
 */
@property (nonatomic, assign) BOOL isBlankTouchInVisible;

/**
 自定义出场动画
 */
@property (nonatomic) CABasicAnimation * showAnimation;

/**
 自定义退场动画
 */
@property (nonatomic) CABasicAnimation * dismissAnimation;

/**
 加载nib文件的构造函数
 */
+ (instancetype)viewWithNib;

/**
 实现为子视图添加出场动画，对多个子视图定制
 */
- (void)addSubviewShowAnimation;

/**
 实现为子视图添加退场动画，对多个子视图定制
 */
- (void)addSubviewDismissAnimation;

/**
 退场
 @param block 退场回调
 */
- (void)dismiss:(void(^)(void))block;

/**
 出场
 @param block 出场回调
 */
- (void)show:(void(^)(void))block;

/**
 出场，指定控制器

 @param block 出场回调
 @param viewController 可以是viewController、tabBarViewController、navigationController等
 */
- (void)show:(void(^)(void))block in:(UIViewController *)viewController;

/**
 退场回调拦截
 */
- (void)receiveDismissed:(void(^)(void))block;

@end
