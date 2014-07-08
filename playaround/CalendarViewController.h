//
//  CalendarViewController.h
//  playaround
//
//  Created by Yingang Xue on 6/23/14.
//  Copyright (c) 2014 Yingang Xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray *cellsInMonth;
  //  NSArray *cellsOfMonth;
    
  //  NSDate *firstDateOfThisMonth;
    
    int numberOfDays;
  //  int numberOfWeeks;
    
    int currentMonth;
    int currentYear;

    int cellViewMonth;//cell 显示哪个月份看这个参数
    
    BOOL scrollDirectionDetermined;
}

//@property (nonatomic,retain) UICollectionView *calendarView;
@property (nonatomic,retain) UICollectionView *monthsView;


@end
