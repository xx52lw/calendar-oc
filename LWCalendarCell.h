//
//  LWCalendarCell.h
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWCalendarDataModel;

@interface LWCalendarCell : UICollectionViewCell

/** 日历cell */
@property (nonatomic,strong) UIButton    *   cellItem;
/** 日历数据模型 */
@property (nonatomic,strong) LWCalendarDataModel    *     dataModel;

@end
