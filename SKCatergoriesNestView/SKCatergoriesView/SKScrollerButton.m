//
//  SKScrollerButton.m
//  SKCatergoriesNestView
//
//  Created by sunke on 2020/4/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

// UIButton -UIScrollView -单个底层UILabel - (UIView UIView UIView 选中 顶部UILabel) - UIButton

#import "SKScrollerButton.h"
#import "NSString+Size.h"

@interface SKScrollerButton ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger selectIdx;
///单个组件的宽度
@property (nonatomic, assign) CGFloat viewWidth;
///单个组件的高度
@property (nonatomic, assign) CGFloat viewHeight;
///所有的Lable rect
@property (nonatomic, strong) NSMutableArray *viewRects;
/// 旧标题数组
@property (nonatomic, strong) NSArray *oldTitle;

@property (nonatomic, strong) UIView *heightLightView;
@property (nonatomic, strong) UIView *heightTopView;
@property (nonatomic, strong) UIView *heightColoreView;
@property (nonatomic, strong) UIView *bottomLine;
/// 底部的label
@property (nonatomic, strong) NSMutableArray *bottomLabelArray;
/// 顶部的label
@property (nonatomic, strong) NSMutableArray *topLabelArray;
/// 顶部的button
@property (nonatomic, strong) NSMutableArray *topBtnArray;
/// 提示的点
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, copy) ButtonOnClickBlock buttonBlock;
@property (nonatomic, copy) ButtonDoubleClickBlock doubleBlock;
@property (nonatomic, copy) ButtonClickBlock buttonClick;
@property (nonatomic, strong) UIScrollView *bottom;

@end


@implementation SKScrollerButton


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        _duration = DEFAULT_DURATION;
        self.selectIdx = 0;
        self.isShowLine = YES;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_bottomLine != nil) { return; }
    [self createBottomLabels];
    [self createTopLables];
    [self createTopButtons];
}

#pragma mark - set method
- (void)setButtonPositionWithScrollView:(UIScrollView *)scrollView {
    
    self.isScroller = YES;
    CGFloat selectPage = scrollView.contentOffset.x/nScreenWidth();
    if (selectPage > self.titles.count - 1 || selectPage < 0) {
        return;
    }
    
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    
    NSInteger idx = floor(selectPage);
    CGFloat position = selectPage - idx;
    
    CGFloat distance = 0;
    CGFloat x = 0;
    CGFloat lableW = 0;
    
    if (translatedPoint.x <= 0) {
        NSValue *curValue = _viewRects[idx];
        distance = curValue.CGRectValue.size.width+16;
        x = curValue.CGRectValue.origin.x + position*distance;
        lableW = curValue.CGRectValue.size.width;
        //NSLog(@"右滑 ===== %f  %f",position,distance);
    }
    
    
    if (translatedPoint.x > 0) {
        NSValue *nxtValue = _viewRects[idx];
        idx = (NSInteger)ceil(selectPage);
        NSValue *curValue = _viewRects[idx];
        distance = nxtValue.CGRectValue.size.width+16;
        CGFloat k = 0;
        if (position != 0) {
            k = (1-position)*distance;
        }
        x = curValue.CGRectValue.origin.x - k;
        lableW = curValue.CGRectValue.size.width;
        if (nxtValue.CGRectValue.size.width < curValue.CGRectValue.size.width) {
            CGFloat disW = fabs(nxtValue.CGRectValue.size.width-curValue.CGRectValue.size.width);
            lableW -= disW;
        }
        //NSLog(@"左滑 ===== %f  %f",position,distance);
    }
    if (self.isShowLine) {
        self.bottomLine.left = x;
    }
    self.heightLightView.frame = CGRectMake(x, 0, lableW+16, _viewHeight-2);
    self.heightTopView.left = -x;
    
    self.selectIdx = idx;
}
-(void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.bottomLine.backgroundColor = lineColor;
}

- (void)setButtonDoubleClickBlock:(ButtonDoubleClickBlock)block {
    if (block) {
        _doubleBlock = block;
    }
}
-(void)setButtonOnClickBlock: (ButtonOnClickBlock) block {
    if (block) {
        _buttonBlock = block;
    }
}

-(void)setButtonClickBlock:(ButtonClickBlock)block{
    if (block) {
        _buttonClick = block;
    }
}


-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    if ([_oldTitle isEqualToArray:titles]) {
        return;
    }
    _totalWidth = 0;
    _viewRects = [[NSMutableArray alloc] init];
    CGRect oldRect = CGRectZero;
    for (int i = 0 ; i < titles.count; i ++) {
        NSString *title = titles[i];
        CGFloat width = [title widthForMaxHeight:19 font:FONTBOLDSIZE(16)];
        CGRect rect = CGRectMake(oldRect.origin.x + oldRect.size.width+16, 0, width, _viewHeight-2);
        [_viewRects addObject:[NSValue valueWithCGRect:rect]];
        oldRect = rect;
        _totalWidth += width;
    }
    _totalWidth += (titles.count)*16;
    
    if (_oldTitle) {
        [self updateTitle];
    }
    
    _oldTitle = [titles mutableCopy];
}


- (void)updateTitle {
    self.bottom.width = _totalWidth;
    NSValue *value = _viewRects[self.selectIdx];
    CGFloat lableW = value.CGRectValue.size.width;
    CGFloat x = value.CGRectValue.origin.x;
    _heightTopView.width = _totalWidth;
    _heightTopView.left = -x;
    
    _heightLightView.width = lableW;
    _heightLightView.left = x;
    
    _heightColoreView.width = lableW;
    
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *btmLb = _bottomLabelArray[i];
        CGRect currentLabelFrame = [self countCurrentRectWithIndex:i];
        btmLb.frame = currentLabelFrame;
        NSString *title = _titles[i];
        btmLb.text = title;
        
        UILabel *topLb = _topLabelArray[i];
        topLb.frame = currentLabelFrame;
        topLb.text = title;
        
        UIButton *btn = _topBtnArray[i];
        btn.frame = currentLabelFrame;
        
        CALayer *cl = _pointArray[i];
        cl.left = (currentLabelFrame.origin.x+currentLabelFrame.size.width);
    }
    
}

-(void)setPoints:(NSArray<NSNumber *> *)points {
    _points = points;
    if (_pointArray.count == 0) {
        return;
    }
    for (int i = 0 ; i < _pointArray.count; i ++) {
        CALayer *cl = _pointArray[i];
        cl.hidden = ![points containsObject:[NSNumber numberWithInt:i]];
    }
}

#pragma mark - UI
/**
 *  计算当前高亮的Frame
 *
 *  @param index 当前点击按钮的Index
 *
 *  @return 返回当前点击按钮的Frame
 */
- (CGRect)countCurrentRectWithIndex:(NSInteger)index {
    NSValue *value = _viewRects[index];
    return  CGRectMake(value.CGRectValue.origin.x, 0, value.CGRectValue.size.width, _viewHeight-2);
}

/**
 *  根据索引创建Label
 *
 *  @param index     创建的第几个Index
 *  @param textColor Label字体颜色
 *
 *  @return 返回创建好的label
 */
- (UILabel *)createLabelWithTitlesIndex:(NSInteger)index
                               textFont:(UIFont *)textFont
                              textColor:(UIColor *)textColor {
    CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
    tempLabel.textColor = textColor;
    tempLabel.text = _titles[index];
    tempLabel.font = textFont;
    tempLabel.minimumScaleFactor = 0.1f;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    return tempLabel;
}

/**
 *  创建最底层的Label
 */
- (void)createBottomLabels {
    _bottomLabelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *tempLabel = [self createLabelWithTitlesIndex:i textFont:_titlesFont?:FONTSIZE(16) textColor:_titlesCustomeColor];
        [self.bottom addSubview:tempLabel];
        [_bottomLabelArray addObject:tempLabel];
    }
}

/**
 *  创建上一层高亮使用的Label
 */
- (void)createTopLables {
    NSValue *value = _viewRects[0];
    CGFloat labelW = value.CGRectValue.size.width;
    
    //label层上的view
    CGRect heightLightViewFrame = CGRectMake(0, 0, labelW+16, _viewHeight-2);
    _heightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightLightView.clipsToBounds = YES;
    
    //动画元素
    _heightColoreView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightColoreView.backgroundColor = _backgroundHeightLightColor;
    if (_radiusBtn > 0) {
        _heightColoreView.layer.cornerRadius = _radiusBtn;
    }
    [_heightLightView addSubview:_heightColoreView];
    
    _heightTopView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _totalWidth, _viewHeight)];
    
    _topLabelArray = [[NSMutableArray alloc] init];
    _pointArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textFont:_titlesHeightFont?:FONTSIZE(16) textColor:_titlesHeightLightColor];
        [_heightTopView addSubview:label];
        [_topLabelArray addObject:label];
        CALayer *cl = [[CALayer alloc] init];
        cl.frame = CGRectMake((label.left+label.width)-5, 5, 10, 10);
        cl.backgroundColor = WARNINGCOLOR().CGColor;
        cl.masksToBounds = YES;
        cl.cornerRadius = 5;
        cl.hidden = ![_points containsObject:[NSNumber numberWithInt:i]];
        [self.layer addSublayer:cl];
        [_pointArray addObject:cl];
    }
    [_heightLightView addSubview:_heightTopView];
    
    [self.bottom addSubview:_heightLightView];
}
/**
 *  创建按钮
 */
- (void)createTopButtons {
    _topBtnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        CGRect tempFrame = [self countCurrentRectWithIndex:i];
        UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
        tempButton.tag = i;
        [tempButton addTarget:self action:@selector(doubleClick:) forControlEvents:UIControlEventTouchDownRepeat];
        [tempButton  addTarget:self action:@selector(singleClick:) forControlEvents:UIControlEventTouchDown];
        [self.bottom addSubview:tempButton];
        [_topBtnArray addObject:tempButton];
    }
    if (self.isShowLine) {
        NSValue *value = _viewRects[0];
        CGFloat labelW = value.CGRectValue.size.width;
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(16, _viewHeight-12, _lineWidth?:labelW, 2)];
        _bottomLine.backgroundColor = self.titlesHeightLightColor;
        [_bottomLine.layer setMasksToBounds:YES];
        [_bottomLine.layer setCornerRadius:1];
        [self.bottom addSubview:_bottomLine];
    }
}

/**
 *  点击按钮事件
 *
 *  @param button 点击的相应的按钮
 */
-(void)singleClick:(UIButton *)button{
    [self performSelector:@selector(tapButton:) withObject:button afterDelay:0.2];
}
-(void)doubleClick:(UIButton *)button{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapButton:) object:button];
    !self.doubleBlock ?: self.doubleBlock(button.tag);
}
- (void)tapButton:(UIButton *) sender {
    self.selectIdx = sender.tag;
    if (_buttonBlock && sender.tag < _titles.count) {
        _buttonBlock(sender.tag, _titles[sender.tag]);
    }
    
    if (_buttonClick && sender.tag < _titles.count) {
        _isScroller = YES;
        _buttonClick(sender.tag);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isScroller = NO;
        });
    }
    
    [self animationSelectPage:sender.tag];
}

- (void)animationSelectPage:(NSInteger)page {
    
    NSValue *value = _viewRects[page];
    CGFloat lableW = value.CGRectValue.size.width;
    CGFloat x = value.CGRectValue.origin.x;
    
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:_duration animations:^{
        weak_self.heightLightView.frame = CGRectMake(x, 0, lableW, weak_self.viewHeight-2);
        weak_self.heightTopView.left = -x;
        if (weak_self.isShowLine) {
            weak_self.bottomLine.left = x;
        }
    } completion:^(BOOL finished) {}];
    
    [self scrollAnimation:page];
}

-(void)scrollAnimation:(NSInteger)idx{
    
    if (_totalWidth <= self.frame.size.width) {
        return;
    }
    NSValue *value = _viewRects[idx];
    CGRect rect = value.CGRectValue;
    CGFloat x = rect.origin.x;
    CGFloat middle = self.frame.size.width/2.0;
    
    if (x > middle) {
        CGFloat btnMid = rect.size.width/2.0;
        x = (rect.origin.x+btnMid)-middle;
        if ((x + self.frame.size.width) > _bottom.contentSize.width) {
            x = _bottom.contentSize.width - self.frame.size.width;
            if (x == _bottom.contentOffset.x) { return; }
        }
    }else{
        if (_bottom.contentOffset.x > 0) {
            x = 0;
        }else{ return; }
    }
    [_bottom setContentOffset:CGPointMake(x, 0) animated:YES];
}
-(UIScrollView *)bottom {
    if (_bottom == nil) {
        BOOL b = (_totalWidth > self.frame.size.width);
        CGFloat width = b?(self.frame.size.width):_totalWidth;
        CGFloat height = self.frame.size.height-1;
        _bottom = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, width,height)];
        _bottom.showsHorizontalScrollIndicator = NO;
        _bottom.showsVerticalScrollIndicator = NO;
        if (b) {
            _bottom.contentSize = CGSizeMake(_totalWidth+16, height);
        }
        _bottom.delegate = self;
        [self addSubview:_bottom];
    }
    return _bottom;
}

@end
