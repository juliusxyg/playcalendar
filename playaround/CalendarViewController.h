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
    
    NSDate *firstDateOfThisMonth;
    
    int numberOfDays;
    int numberOfWeeks;
}

@property (nonatomic,retain) UICollectionView *calendarView;

@end
