//
//  SKScrollerButton.h
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//
// 标题栏
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const DEFAULT_DURATION = .4f;

typedef void(^ButtonOnClickBlock)(NSInteger tag, NSString * title);
typedef void(^ButtonClickBlock)(NSInteger tag);
typedef void(^ButtonDoubleClickBlock)(NSInteger tag);


@interface SKScrollerButton : UIView
///标题数组
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray <NSNumber *>*points;
///标题的常规颜色
@property (nonatomic, strong) UIColor *titlesCustomeColor;
///标题高亮颜色
@property (nonatomic, strong) UIColor *titlesHeightLightColor;
///线的颜色
@property (nonatomic, strong) UIColor *lineColor;
///高亮时的颜色
@property (nonatomic, strong) UIColor *backgroundHeightLightColor;
///标题的字号
@property (nonatomic, strong) UIFont *titlesFont;
///标题高亮的字号
@property (nonatomic, strong) UIFont *titlesHeightFont;
///运动时间
@property (nonatomic, assign) CGFloat duration;
///每行的个数（默认5个）
@property (nonatomic, assign) NSInteger number;
///边框的圆角
@property (nonatomic, assign) CGFloat radiusBtn;
///是否处于滑动状态
@property (nonatomic, assign) BOOL isScroller;
///是否显示线 (默认YES 显示)
@property (nonatomic, assign) BOOL isShowLine;
///是否显示点
@property (nonatomic, assign) BOOL isShowPoint;
///组件总长度
@property (nonatomic, assign) CGFloat totalWidth;
///线的总长度
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setButtonOnClickBlock: (ButtonOnClickBlock) block;
- (void)setButtonClickBlock: (ButtonClickBlock) block;
- (void)setButtonDoubleClickBlock:(ButtonDoubleClickBlock)block;

- (void)setButtonPositionWithScrollView:(UIScrollView *)scrollView;
- (void)animationSelectPage:(NSInteger)page;
- (void)scrollAnimation:(NSInteger)idx;

@end

NS_ASSUME_NONNULL_END
