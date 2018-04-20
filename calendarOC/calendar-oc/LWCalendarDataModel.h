//
//  LWCalendarDataModel.h
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWCalendarDataModel : NSObject

/** 日期年月 */
@property (nonatomic,strong)                    NSString  *   yearMonth;
/** 显示日期 */
@property (nonatomic,copy)                      NSString  *   day;
/** 是否选中 */
@property (nonatomic,assign, getter=isSelected) BOOL          selected;
/** 是否在当前月 */
@property (nonatomic,assign, getter=isCurrtenMonth) BOOL   currentMonth;

@end
