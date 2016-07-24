//
//  LWCalendarCell.m
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import "LWCalendarCell.h"
#import "LWCalendarDataModel.h"
#import "LWCalendarConfig.h"
// ==================================================================================================================================================================
@implementation LWCalendarCell

- (UIButton *)cellItem
{
    if (_cellItem == nil) {
        _cellItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _cellItem.backgroundColor = [UIColor clearColor];
        _cellItem.userInteractionEnabled = NO;
    }
    return _cellItem;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kLWCalendarCellBgColor;
        [self addSubview:self.cellItem];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cellItem.frame = self.bounds;
    self.cellItem.layer.cornerRadius = MIN(self.cellItem.frame.size.width, self.cellItem.frame.size.height) * 0.5f;
    self.cellItem.layer.masksToBounds = YES;
    self.cellItem.layer.borderWidth = 1.0f;
}

- (void)setDataModel:(LWCalendarDataModel *)dataModel
{
    _dataModel = dataModel;
    
    [self.cellItem setTitle:_dataModel.day forState:UIControlStateNormal];
    self.cellItem.selected = _dataModel.isSelected;
    if (self.cellItem.selected == YES)
        self.cellItem.layer.borderColor = [UIColor redColor].CGColor;
    else
        self.cellItem.layer.borderColor = [UIColor blackColor].CGColor;
    if (dataModel.isCurrtenMonth == NO) {
        self.cellItem.backgroundColor = [UIColor colorWithRed:255.0/255 green:244.0/255 blue:218.0/255 alpha:1.0];
    }
    else if ([self isToday])
        self.cellItem.backgroundColor = [UIColor redColor];
    else
        self.cellItem.backgroundColor = [UIColor clearColor];
    
    [self.cellItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (BOOL)isToday
{
    BOOL is = NO;
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd";
    NSString *nowStrig = [f stringFromDate:nowDate];
    if ([nowStrig isEqualToString:[NSString stringWithFormat:@"%@-%@",self.dataModel.yearMonth,self.dataModel.day]]) {
        is = YES;
    }
    return is;
}

@end
// ==================================================================================================================================================================