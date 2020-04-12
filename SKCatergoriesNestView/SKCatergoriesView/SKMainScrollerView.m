//
//  SKMainScrollerView.m
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "SKMainScrollerView.h"
#import "SKScrollView.h"

// 单线宽度230
static CGFloat const SLIDINGWIDTH = 230;

@interface SKMainScrollerView() <UIScrollViewDelegate> {
    CGFloat _y;
}
@property (nonatomic ,assign) BOOL isClick;
@property (nonatomic,weak) SKScrollView *scrollview;

@end

@implementation SKMainScrollerView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        self.backgroundColor = COLORFFFFFF();
        
    }
    return self;
}
-(void)createView {
    
    SKScrollerButton *scroller = [[SKScrollerButton alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(),44)];
    scroller.totalWidth = SLIDINGWIDTH;
    
    scroller.backgroundHeightLightColor = COLORFFFFFF();
    scroller.titlesHeightLightColor = [UIColor redColor];
    scroller.titlesCustomeColor = GRAYCOLOR();
    _scroller = scroller;
    
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 43.5, nScreenWidth(), 0.5);
    line.backgroundColor = COLOREDEDED().CGColor;
    [scroller.layer addSublayer:line];
    
    __weak typeof(self) ws = self;
    [_scroller setButtonClickBlock:^(NSInteger tag) {
        if (tag == ws.selectPage) {
            return;
        }
        ws.isClick = YES;
        [ws setSelect:tag];
        [ws.scrollview setContentOffset:CGPointMake(tag*nScreenWidth(), 0) animated:NO];
        if (ws.srollerAction) {
            ws.srollerAction(tag);
        }
    }];
    [_scroller setButtonDoubleClickBlock:^(NSInteger tag) {
        !ws.doubleClick ?: ws.doubleClick(tag);
    }];
    [self addSubview:scroller];
    
    
    _y = CGRectGetHeight(scroller.frame);
    SKScrollView *scrollview = [[SKScrollView alloc] init];
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.delegate = self;
    scrollview.bounces = NO;
    [self addSubview:scrollview];
    self.scrollview = scrollview;
}

- (void)setSelect:(NSInteger)tag {
    _selectPage = tag;
}

#pragma --mark FiltrateFunction

#pragma --mark setFunction

-(void)setTitles:(NSArray *)titles {
    _titles = titles;
    _scroller.titles = titles;
}
-(void)setPoints:(NSArray<NSNumber *> *)points {
    _points = points;
    _scroller.points = points;
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _scroller.lineColor = lineColor;
}
-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _scroller.lineWidth = lineWidth;
}
-(void)setTextFont:(CGFloat)textFont
{
    _textFont = textFont;
    _scroller.titlesFont = FONTSIZE(textFont);
}
- (void)setFont:(UIFont *)font {
    _font = font;
    _scroller.titlesFont = font;
}
- (void)setHeightFont:(UIFont *)heightFont {
    _heightFont = heightFont;
    _scroller.titlesHeightFont = heightFont;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _scroller.titlesHeightLightColor = textColor;
}
-(void)setViewController:(UIViewController *)viewController{
    _viewController = viewController;
    _scrollview.frame = CGRectMake(0, _y, nScreenWidth(), self.height-_y);
    _scrollview.viewController = viewController;
}

-(void)setSelectPage:(NSInteger)selectPage{
    if (self.titles.count <= selectPage) {
        return;
    }
    _selectPage = selectPage;
    if (self.titles.count - 1 < selectPage) {
        return;
    }
    CGFloat x = nScreenWidth()*selectPage;
    self.isClick = YES;
    [_scrollview setContentOffset:CGPointMake(x, 0) animated:NO];
    [_scroller animationSelectPage:selectPage];
    !self.srollerAction ?: self.srollerAction(selectPage);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = scrollView.contentOffset.x/nScreenWidth();
    _selectPage = i;
    !self.srollerAction ?: self.srollerAction(i);
    [_scroller scrollAnimation:i];
}
- (void)setTopViewColor:(UIColor *)topViewColor
{
    _topViewColor = topViewColor;
    _scroller.backgroundHeightLightColor = topViewColor;
    _scroller.backgroundColor = topViewColor;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isClick = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isClick) return;
    [_scroller setButtonPositionWithScrollView:scrollView];
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    _scrollview.viewControllers = viewControllers;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //    _scroller.titles = self.titles;
    _scrollview.contentSize = CGSizeMake(self.titles.count*nScreenWidth(), _y);
    
}
-(void)dealloc{
    
    NSLog(@"%s",__func__);
}


@end
