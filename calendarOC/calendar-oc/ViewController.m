//
//  ViewController.m
//  calendar-oc
//
//  Created by liwei on 2018/4/20.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "ViewController.h"
#import "LWCalendarView.h"
// ==================================================================================================================================================================
@interface ViewController ()

@property (nonatomic,strong) LWCalendarView   *     calendarView;  // 日历View

@end
// ==================================================================================================================================================================
@implementation ViewController

#pragma mark 懒加载日历View
- (LWCalendarView *)calendarView
{
    if (_calendarView == nil) {
        CGFloat h = 300.0f;
        CGRect frame = CGRectMake(0, (self.view.frame.size.height - h) * 0.5f, self.view.frame.size.width, h);
        _calendarView = [[LWCalendarView alloc] initWithFrame:frame];
        _calendarView.showDate = [NSDate date];
    }
    return _calendarView;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.calendarView];
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    CGFloat h = 200.0f;
//    self.calendarView.frame = CGRectMake(0, (self.view.frame.size.height - h) * 0.5f, self.view.frame.size.width, h);
//}

@end
// ==================================================================================================================================================================
