//
//  LWCalendarView.m
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import "LWCalendarView.h"
#import "LWCollectionViewCell.h"
#import "LWCalendarTool.h"
#import "LWCalendarDataModel.h"
#import "LWCalendarConfig.h"
// ==================================================================================================================================================================
static NSString *const identifier = @"LWCollectionViewCell"; // 注册ID

// ==================================================================================================================================================================
#pragma mark - 日历View
@interface LWCalendarView()

@property (nonatomic,strong) UIView              *     topView;        // 顶部View
@property (nonatomic,strong) UILabel             *     dateLabel;      // 显示日期
@property (nonatomic,strong) UIView              *     weekView;       // 展示星期
@property (nonatomic,strong) NSArray             *     weekArray;      // 星期数组
@property (nonatomic,strong) UICollectionView    *     collectionView; // 日历展示
@property (nonatomic,strong) LWCalendarTool      *     tool;           // 日期工具类
@property (nonatomic,strong) NSMutableArray<LWCalendarDataModel *>    *     selectedArray; // 存放选择的要标记的日期

@end
// ==================================================================================================================================================================
#pragma mark - 日历View
@interface LWCalendarView(tools)

- (void)formateTopShow; // 格式化要显示当前要展示的年月

@end
// ==================================================================================================================================================================
#pragma mark - 日历View(UICollectionViewDelegateDataSource)
@interface LWCalendarView(UICollectionViewDelegateDataSource)<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
// ==================================================================================================================================================================
#pragma mark - 日历View
@implementation LWCalendarView
#pragma mark 懒加载top（用于展示当前显示的年月）
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        self.dateLabel = [[UILabel alloc] initWithFrame:_topView.bounds];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:self.dateLabel];
        _topView.backgroundColor = kLWCalendarYearMonthBgColor;
    }
    return _topView;
}
#pragma mark 星期数组
- (NSArray *)weekArray
{
    if (_weekArray == nil) {
        _weekArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _weekArray;
}
#pragma mark 懒加载星期展示样式
- (UIView *)weekView
{
    if (_weekView == nil) {
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.frame.size.width, 50)];
        for (int i = 0; i < self.weekArray.count; ++i) { // 把每天平均分布，可以根据自己的需求更改展示的样式
            CGFloat w = _weekView.frame.size.width / self.weekArray.count;
            UILabel *weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(w * i, 0, w, _weekView.frame.size.height)];
            weekDayLabel.text = [self.weekArray objectAtIndex:i];
            weekDayLabel.textAlignment = NSTextAlignmentCenter;
            weekDayLabel.textColor = [UIColor blackColor];
            [_weekView addSubview:weekDayLabel];
        }
        _weekView.backgroundColor = kLWCalendarWeakColor;
    }
    return _weekView;
}

#pragma mark 日历展示 （主要存放三个collection,实现无限显示日期）
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        CGFloat y = CGRectGetMaxY(self.weekView.frame);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.height - y) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LWCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}
#pragma mark 懒加载工具类
- (LWCalendarTool *)tool
{
    if (_tool == nil) {
        _tool = [[LWCalendarTool alloc] init];
    }
    return _tool;
}
#pragma mark 懒加载选择数组
- (NSMutableArray *)selectedArray
{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark 重写initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
         [self.selectedArray removeAllObjects];
        [self addSubview:self.topView];
        [self addSubview:self.weekView];
        [self addSubview:self.collectionView];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    return self;
}

- (void)setShowDate:(NSDate *)showDate
{
    _showDate = showDate;
    [self formateTopShow];
}

@end
// ==================================================================================================================================================================
#pragma mark - 日历View(UICollectionViewDelegateDataSource)
@implementation LWCalendarView(UICollectionViewDelegateDataSource)

#pragma mark 三组（前一个月，当前月，下一个月）
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark 每组的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}
#pragma mark 样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.section = indexPath.row;
    cell.selectedArray = self.selectedArray;
    if (indexPath.row == 0) {
        cell.showDate = [self.tool preMonthToThisMonth:self.showDate];
    }
    else if (indexPath.row == 1)
    {
        cell.showDate = self.showDate;
    }
    else
        cell.showDate = [self.tool nextMonthToThisMonth:self.showDate];
    
    return cell;
}
#pragma mark 判断滚动的位置（无论向前滚还是向后滚，当滚动结束后都停靠在中间，并根据滚动的方向刷新数据，进而实现无限循环的效果）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.frame.size.width * 1.5) { // 向后滚
        self.showDate = [self.tool nextMonthToThisMonth:self.showDate];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.collectionView reloadData];
        [self formateTopShow];
    }
    else if (scrollView.contentOffset.x < self.frame.size.width * 0.5) // 向前滚
    {
        self.showDate = [self.tool preMonthToThisMonth:self.showDate];
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self formateTopShow];
    }
}

@end

// ==================================================================================================================================================================
#pragma mark - 日历View
@implementation LWCalendarView(tools)

- (void)formateTopShow
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM";
    self.dateLabel.text = [f stringFromDate:self.showDate];
}


@end

// ==================================================================================================================================================================