//
//  LWCalendarTool.h
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWCalendarTool : NSObject

/** 当前日期所在月的第几天 */
- (NSInteger)dayInDate:(NSDate *)date;
/** 当前日期所在年的第几月 */
- (NSInteger)monthInDate:(NSDate *)date;
/** 当前日期所在年 */
- (NSInteger)yearInDate:(NSDate *)date;
/** 当前日期所在月的第一天是周几 */
- (NSInteger)firstWeekDayInThisMonth:(NSDate *)date;
/** 当前日期所在月有多少天 */
- (NSInteger)daysInThisMonth:(NSDate *)date;
/** 当前日期的上个月日期 */
- (NSDate *)preMonthToThisMonth:(NSDate *)date;
/** 当前日期的下一个月日期 */
- (NSDate *)nextMonthToThisMonth:(NSDate *)date;

@end
