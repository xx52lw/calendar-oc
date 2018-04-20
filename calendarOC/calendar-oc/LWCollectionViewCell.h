//
//  LWCollectionViewCell.h
//  calendar-oc
//
//  Created by 张星星 on 16/7/23.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWCalendarDataModel;

@interface LWCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDate    *     showDate;
@property (nonatomic,assign) NSInteger  section;
@property (nonatomic,strong) NSMutableArray<LWCalendarDataModel *>    *     selectedArray;

@end
