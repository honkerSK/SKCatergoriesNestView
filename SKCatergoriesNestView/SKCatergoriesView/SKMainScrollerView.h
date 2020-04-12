//
//  SKMainScrollerView.h
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKScrollerButton.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^SrollerClick)(NSInteger tag);
typedef void (^DoubleClick)(NSInteger tag);

@interface SKMainScrollerView : UIView

@property (nonatomic,weak) SKScrollerButton *scroller;
/// 分类数组
@property (nonatomic,strong) NSArray *titles;
/// 红点数组
@property (nonatomic, strong) NSArray <NSNumber *>*points;
/// 容器控制器
@property (nonatomic,weak) UIViewController *viewController;
/// 子控制器数组
@property (nonatomic,strong) NSArray *viewControllers;

@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
/// 高亮时的颜色
@property (nonatomic,strong) UIColor *topViewColor;
/// 标题的字号
@property (nonatomic,assign) CGFloat textFont;
/// 标题的字号
@property (nonatomic,strong) UIFont *font;
/// 标题高亮的字号
@property (nonatomic,strong) UIFont *heightFont;
/// 标题高亮颜色
@property (nonatomic,strong) UIColor *textColor;
/// 选中的第几个子控制器
@property (nonatomic,assign) NSInteger selectPage;
/// 单机某个标题栏 回调block
@property (nonatomic,copy) SrollerClick srollerAction;
/// 双击某个标题栏 回调block
@property (nonatomic, copy) DoubleClick doubleClick;

@end

NS_ASSUME_NONNULL_END
