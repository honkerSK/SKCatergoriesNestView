//
//  MainViewController.m
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "MainViewController.h"
#import "SKMainScrollerView.h"
#import "SubViewController.h"


@interface MainViewController ()

@property (nonatomic, weak) SKMainScrollerView *scroll;

@property (nonatomic ,weak) UIViewController *disCharaVC;
@property (nonatomic ,weak) SubViewController *activityLocVC;
@property (nonatomic ,weak) UIViewController *circleVC;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //PrefixHeader.pch 导入 SKCatergoriesNestView.h
    WeakSelf
    NSArray <NSString *>*titles = @[@"头条",@"游戏",@"数码"];
    SKMainScrollerView *scroll = [[SKMainScrollerView alloc] initWithFrame:CGRectMake(0, kSafeAreaTopHeight(), nScreenWidth(), nScreenHeight()-kSafeAreaTopHeight())];
    scroll.titles = titles;
    scroll.textColor = BRANDCOLOR();
    scroll.font = FONTSIZE(16);
    scroll.heightFont = FONTBOLDSIZE(16);
    
    //头条
    UIViewController *disCharaVC = [[UIViewController alloc] init];
    disCharaVC.view.backgroundColor = [UIColor redColor];
    //游戏
    SubViewController *activityLocVC = [[SubViewController alloc] init];
    //数码
    UIViewController *circleVC = [[UIViewController alloc] init];
    circleVC.view.backgroundColor = [UIColor blueColor];
    
    //单击某个标题栏
    scroll.srollerAction = ^(NSInteger tag) {
        NSLog(@"单击某个标题栏= %ld", tag);
    };
    //双击某个标题栏
    scroll.doubleClick = ^(NSInteger tag) {
        NSLog(@"双击某个标题栏= %ld", tag);
    };
    scroll.viewController = self;
    scroll.viewControllers = @[disCharaVC,activityLocVC,circleVC];
    [self.view addSubview:scroll];
    self.scroll = scroll;
    
    //延时2s
    kDISPATCH_AFTER(0.2, ^{
        //默认选中 游戏
        weakSelf.scroll.selectPage = 1;
    });
    
    //保存子控制器
    self.disCharaVC = disCharaVC;
    self.activityLocVC = activityLocVC;
    self.circleVC = circleVC;
    
    
}




@end
