//
//  SKScrollView.h
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKScrollView : UIScrollView
@property (nonatomic,weak) UIViewController *viewController;
@property (nonatomic,strong) NSArray *viewControllers;
@end

NS_ASSUME_NONNULL_END
