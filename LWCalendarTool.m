//
//  LWCalendarTool.m
//  calendar-oc
//
//  Created by 张星星 on 16/7/22.
//  Copyright © 2016年 张星星. All rights reserved.
//

#import "LWCalendarTool.h"

@implementation LWCalendarTool

#pragma mark 当前日期所在月的第几天
- (NSInteger)dayInDate:(NSDate *)date
{
    return [[self componentsFromeDate:date] day];
}
#pragma mark 当前日期所在年的第几月
- (NSInteger)monthInDate:(NSDate *)date
{
    return [[self componentsFromeDate:date] month];
}
#pragma mark 当前日期所在年
- (NSInteger)yearInDate:(NSDate *)date
{
    return [[self componentsFromeDate:date] year];
}
#pragma mark 当前日期所在月的第一天是周几
- (NSInteger)firstWeekDayInThisMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1]; // 1.Sun(周日) 2.Mon(周一) ... 7.Sat(周六)
    NSDateComponents *components = [self componentsFromeDate:date];
    [components setDay:1];
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonth];
    return firstWeekday - 1;
}
#pragma mark 当前日期所在月有多少天
- (NSInteger)daysInThisMonth:(NSDate *)date
{
    NSRange daysRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysRange.length;
}
#pragma mark 当前日期的上个月日期
- (NSDate *)preMonthToThisMonth:(NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1; // 默认是0 上一个是（-1） 下一个是（+1）
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return newDate;
}
#pragma mark 当前日期的下一个月日期
- (NSDate *)nextMonthToThisMonth:(NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = +1; // 默认是0 上一个是（-1） 下一个是（+1）
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return newDate;
}

- (NSDateComponents *)componentsFromeDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components;
}

@end
