//
//  SKCatergoriesNestView.h
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/22.
//  Copyright © 2020 KentSun. All rights reserved.
//

#ifndef SKCatergoriesNestView_h
#define SKCatergoriesNestView_h

#import <UIKit/UIKit.h>
#import <YYCategories/YYCategories.h>

//弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

CG_INLINE UIFont *FONTSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:a];
}
CG_INLINE UIFont *FONTBOLDSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:a];
}

CG_INLINE CGFloat nScreenWidth() {
    return YYScreenSize().width;
}
CG_INLINE CGFloat nScreenHeight() {
    return YYScreenSize().height;
}

CG_INLINE CGFloat kSafeAreaTopHeight() {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

//GCD - 延时
CG_INLINE void kDISPATCH_AFTER(CGFloat seconds,dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

/**
 *  输入RGBA值获取颜色
 *
 *  @param r RED值
 *  @param g GREEN值
 *  @param b BLUE值
 *  @param a 透明度
 *
 *  @return UIColor
 */

CG_INLINE UIColor *RGBACOLOR(CGFloat r,CGFloat g,CGFloat b,CGFloat a) {
    return [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f  alpha:(a)];
}

/**
 输入RGB值获取颜色
 
 @param r RED值
 @param g GREEN值
 @param b BLUE值
 @return UIColor
 */
CG_INLINE UIColor * RGBCOLOR(CGFloat r,CGFloat g,CGFloat b) {
    return [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f  alpha:1];
}
/**
 随机颜色
 
 @return 随机颜色
 */
CG_INLINE UIColor * RandomColor() {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f  alpha:1];
}



//警告色
CG_INLINE UIColor *WARNINGCOLOR() {
    return RGBACOLOR(230, 47, 92, 1.0);
}
// 白色
CG_INLINE UIColor *COLORFFFFFF() {
    return [UIColor whiteColor];
}
// 灰色 COLOR888888
CG_INLINE UIColor *GRAYCOLOR() {
    return RGBACOLOR(136, 136, 136, 1.0);
}
// 灰色 分割线颜色
CG_INLINE UIColor *COLOREDEDED() {
    return RGBACOLOR(237, 237, 237, 1.0);
}
//品牌色
CG_INLINE UIColor *BRANDCOLOR() {
    return RGBACOLOR(0, 212, 231, 1.0);
}


#pragma mark ————— 偏好设置UserDefault —————

/**
 用户设置偏好设置
 
 @param keyName 偏好名称
 @param object 值
 */
CG_INLINE void UserDefaults_Set_WithKey(NSString *keyName,id object) {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 用户设置偏好获取
 
 @param keyName 偏好名称
 */
CG_INLINE id UserDefaults_Get_WithKey(NSString *keyName) {
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
}
/**
 用户设置偏好删除
 
 @param keyName 偏好名称
 */
CG_INLINE void UserDefaults_Del_WithKey(NSString *keyName) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#endif /* SKCatergoriesNestView_h */
