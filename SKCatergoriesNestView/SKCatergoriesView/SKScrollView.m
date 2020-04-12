//
//  SKScrollView.m
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "SKScrollView.h"

@implementation SKScrollView

-(void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    for (int i = 0; i < viewControllers.count; i ++) {
        UIViewController *vc = viewControllers[i];
        vc.view.frame = CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        NSAssert(self.viewController != nil, @"没有设置代理控制器！");
        [_viewController addChildViewController:vc];
        [self addSubview:vc.view];
    }
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
