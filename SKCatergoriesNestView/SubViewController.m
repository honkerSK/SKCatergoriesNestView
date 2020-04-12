//
//  SubViewController.m
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "SubViewController.h"
#import "SKMainScrollerView.h"
#import "ThirdViewController.h"

const NSString * const KUserDefaultSceneTabs =  @"KUserDefaultSceneTabs";

@interface SubViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RandomColor();
    
    [self setup];
}
- (void)setup {
    //获取偏好设置数据
    NSArray *sceneTabs = UserDefaults_Get_WithKey(KUserDefaultSceneTabs);
    
    NSDictionary *dict = sceneTabs.firstObject;
    if (sceneTabs.count == 0 ||
        ![dict containsObjectForKey:@"tabName"]) {
        sceneTabs = @[@{@"tabName": @"子标题1"},
                      @{@"tabName": @"子标题2"},
                      @{@"tabName": @"子标题3"}];
    }
    self.titles = [[NSMutableArray alloc] init];
    self.viewControllers = [[NSMutableArray alloc] init];
    if (sceneTabs.count > 0) {
        for (NSDictionary *dict in sceneTabs) {
            ThirdViewController *vc = [[ThirdViewController alloc] init];
            [self.viewControllers addObject:vc];
            [self.titles addObject:dict[@"tabName"]];
        }
    }
    
    SKMainScrollerView *scroll = [[SKMainScrollerView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), nScreenHeight()-kSafeAreaTopHeight()-44)];
    scroll.titles = self.titles;
    scroll.textColor = BRANDCOLOR();
    scroll.font = FONTSIZE(16);
    scroll.heightFont = FONTBOLDSIZE(16);
    scroll.scroller.isShowLine = NO;
    
    scroll.srollerAction = ^(NSInteger tag) {
        
    };
    scroll.viewController = self;
    scroll.viewControllers = self.viewControllers;
    [self.view addSubview:scroll];
}




@end
