//
//  LWCollectionViewCell.m
//  calendar-oc
//
//  Created by 张星星 on 16/7/23.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import "LWCollectionViewCell.h"
#import "LWCalendarCell.h"
#import "LWCalendarTool.h"
#import "LWCalendarDataModel.h"
// ==================================================================================================================================================================
#pragma mark -  月的显示视图View
@interface LWCollectionViewCell ()

@property (nonatomic,strong) UICollectionView    *     calendarCell;
@property (nonatomic,strong) LWCalendarTool    *     tool;
@property (nonatomic,strong) NSDate    *     data1; // 之前月的日期
@property (nonatomic,strong) NSDate    *     data2; // 之后月的日期

@end

// ==================================================================================================================================================================
#pragma mark -  月的显示视图View（tools）
@interface LWCollectionViewCell (tools)


- (void)updateData;                    // 更新所有数据
- (NSString *)getYYYYMM:(NSDate *)date;// 得到年月（yyyy-MM格式）
- (BOOL)selectedCellWithDataModel:(LWCalendarDataModel *)model; // 判断是否是标记过的日期

@end

// ==================================================================================================================================================================
#pragma mark -  月的显示视图View（UICollectionViewDelegateDataSource）
@interface LWCollectionViewCell (UICollectionViewDelegateDataSource)<UICollectionViewDelegate,UICollectionViewDataSource>

@end

// ==================================================================================================================================================================
@implementation LWCollectionViewCell
#pragma mark 日历展示
- (UICollectionView *)calendarCell
{
    if (_calendarCell == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 2.0f;
        layout.minimumInteritemSpacing = 2.0f;
        _calendarCell = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _calendarCell.backgroundColor = [UIColor clearColor];
        _calendarCell.bounces = NO;
        _calendarCell.delegate = self;
        _calendarCell.dataSource = self;
        _calendarCell.scrollEnabled = NO;
        _calendarCell.showsHorizontalScrollIndicator = NO;
        [_calendarCell registerClass:[LWCalendarCell class] forCellWithReuseIdentifier:@"LWCalendarCell"];
    }
    return _calendarCell;
}

- (LWCalendarTool *)tool
{
    if (_tool == nil) {
        _tool = [[LWCalendarTool alloc] init];
    }
    return _tool;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.calendarCell];
    }
    return self;
}
- (void)setShowDate:(NSDate *)showDate
{
    _showDate = showDate;
    [self updateData];
    [self.calendarCell reloadData];
}

@end
// ==================================================================================================================================================================
#pragma mark -  月的显示视图View（tools）
@implementation LWCollectionViewCell (tools)


- (NSString *)getYYYYMM:(NSDate *)date
{
    NSString *year  = [NSString stringWithFormat:@"%ld",(long)[self.tool yearInDate:date]];
    NSInteger month = [self.tool monthInDate:date];
    if (month > 10)
        return  [NSString stringWithFormat:@"%@-%ld",year,(long)month]; //要保持yyyy-MM
    else
        return  [NSString stringWithFormat:@"%@-0%ld",year,(long)month]; //要保持yyyy-MM
}



- (BOOL)selectedCellWithDataModel:(LWCalendarDataModel *)model
{
    __block BOOL isSelected = NO;
    if (self.selectedArray.count <= 0)
        isSelected = NO;
    else
        [self.selectedArray enumerateObjectsUsingBlock:^(LWCalendarDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.yearMonth isEqualToString:model.yearMonth] && [obj.day isEqualToString:model.day]) {
                isSelected = YES;
                *stop = YES;
            }
        }];
    return isSelected;
}

#pragma mark 更新所有数据
- (void)updateData
{
    self.data1 = [self.tool preMonthToThisMonth:self.showDate];
    self.data2 = [self.tool nextMonthToThisMonth:self.showDate];
}


@end

// ==================================================================================================================================================================
#pragma mark -  月的显示视图View（UICollectionViewDelegateDataSource）
@implementation LWCollectionViewCell (UICollectionViewDelegateDataSource)

#pragma mark 全部布局42个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width - 12) / 7, (self.frame.size.height - 10) / 6);
}
#pragma mark 样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWCalendarCell" forIndexPath:indexPath];
    
    NSInteger daysInCurrentMonth = [self.tool daysInThisMonth:self.showDate];
    NSInteger daysInPreMonth = [self.tool daysInThisMonth:self.data1];
    NSInteger fistWeekdayCurrentMonth = [self.tool firstWeekDayInThisMonth:self.showDate];
    LWCalendarDataModel *dataModel = [[LWCalendarDataModel alloc] init];
    if ( fistWeekdayCurrentMonth > indexPath.row) {
        dataModel.yearMonth = [self getYYYYMM:self.data1]; //要保持yyyy-MM
        dataModel.day = [NSString stringWithFormat:@"%ld",daysInPreMonth - fistWeekdayCurrentMonth + indexPath.row + 1];
        dataModel.currentMonth = NO;
    }
    else if (indexPath.row > daysInCurrentMonth + fistWeekdayCurrentMonth - 1)
    {
        dataModel.yearMonth = [self getYYYYMM:self.data2]; //要保持yyyy-MM
        dataModel.day = [NSString stringWithFormat:@"%ld",indexPath.row - (fistWeekdayCurrentMonth + daysInCurrentMonth) + 1];
        dataModel.currentMonth = NO;
    }
    else
    {
        dataModel.yearMonth = [self getYYYYMM:self.showDate]; //要保持yyyy-MM
        dataModel.day = [NSString stringWithFormat:@"%ld",indexPath.row - fistWeekdayCurrentMonth + 1];
        dataModel.currentMonth = YES;
    }
    dataModel.selected = [self selectedCellWithDataModel:dataModel];
    cell.dataModel = dataModel;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWCalendarCell *cell = (LWCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dataModel.isCurrtenMonth == NO || cell.dataModel.selected == YES)
        return;
    cell.dataModel.selected = YES;
    [self.selectedArray addObject:cell.dataModel];
    [self.calendarCell reloadData];
}

@end
// ==================================================================================================================================================================