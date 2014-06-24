//
//  CalendarViewController.m
//  playaround
//
//  Created by Yingang Xue on 6/23/14.
//  Copyright (c) 2014 Yingang Xue. All rights reserved.
//

#import "CalendarViewController.h"
#import "DayCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        [tmp addObject:[[NSArray alloc] initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil]];
        [tmp addObject:[self getDayCellsOfMonth:2015 month:5]];
        cellsInMonth = tmp;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
    
    [self.navigationItem setLeftBarButtonItem:menuButton];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY MMM"];
    self.navigationItem.title = [format stringFromDate:firstDateOfThisMonth];
    
    CGRect calendarRect = CGRectMake((320-7*45)/2, 49, 320, (25+45*numberOfWeeks));
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    
    calendarView = [[UICollectionView alloc] initWithFrame:calendarRect collectionViewLayout:flowlayout];
    [calendarView registerClass:[DayCell class] forCellWithReuseIdentifier:@"DayCell"];
    
    calendarView.backgroundColor=[UIColor whiteColor];
    
    calendarView.delegate=self;
    calendarView.dataSource=self;
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openMenu
{}

- (NSArray*)getDayCellsOfMonth:(int)year month:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *aDateComp = [[NSDateComponents alloc] init];
    [aDateComp setYear:year];
    [aDateComp setMonth:month];
    [aDateComp setDay:1];
    NSDate *aDate = [calendar dateFromComponents:aDateComp];
    NSDate *aDateLocale = [aDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:aDate]];
    firstDateOfThisMonth = aDateLocale;
    //NSLog(@"%@", [aDateLocale description]);
    int startWeekDay = [calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:aDateLocale];
    //NSLog(@"%d", startWeekDay);
    //获取这一个月的天数
    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDateLocale];
    //NSLog(@"%d to %d", dayRange.location, dayRange.length);
    NSRange weekRange = [calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDateLocale];
    //NSLog(@"%d to %d", weekRange.location, weekRange.length);
    
    numberOfDays = dayRange.length;
    numberOfWeeks = weekRange.length;
    
    int dayEntriesTotal = numberOfWeeks * 7;
    NSMutableArray *dayEntries = [[NSMutableArray alloc] init];
    
    int dayEntryCount=0;
    //1号以前
    for(int j=1; j<startWeekDay; j++, dayEntryCount++)//startweekday = 2, 1号是星期一
    {
        NSDate *dayOfPerviousMonth = [aDateLocale dateByAddingTimeInterval:-(24*60*60*(startWeekDay-j))];
        NSMutableDictionary *dayEntryDic = [[NSMutableDictionary alloc] init];
        [dayEntryDic setObject:@"NO" forKey:@"inMonth"];
        [dayEntryDic setObject:dayOfPerviousMonth forKey:@"date"];
        [dayEntries addObject:dayEntryDic];
    }
    //当月
    for(int j=1; j<=numberOfDays; j++, dayEntryCount++)
    {
        NSDateComponents *cellDateComp = [[NSDateComponents alloc] init];
        [cellDateComp setYear:year];
        [cellDateComp setMonth:month];
        [cellDateComp setDay:j];
        NSDate *cellDate = [calendar dateFromComponents:cellDateComp];
        NSDate *cellDateLocale = [cellDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:cellDate]];
        NSMutableDictionary *dayEntryDic = [[NSMutableDictionary alloc] init];
        [dayEntryDic setObject:@"YES" forKey:@"inMonth"];
        [dayEntryDic setObject:cellDateLocale forKey:@"date"];
        [dayEntries addObject:dayEntryDic];
    }
    //下个月
    for(; dayEntryCount<dayEntriesTotal; dayEntryCount++)
    {
        NSDate *endDay = [[[dayEntries objectAtIndex:(dayEntryCount-1)] objectForKey:@"date"] dateByAddingTimeInterval:(24*60*60)];
        NSMutableDictionary *dayEntryDic = [[NSMutableDictionary alloc] init];
        [dayEntryDic setObject:@"NO" forKey:@"inMonth"];
        [dayEntryDic setObject:endDay forKey:@"date"];
        [dayEntries addObject:dayEntryDic];
    }
    return dayEntries;
}

#pragma mark - UICollectionView Datasource
// number of items
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [cellsInMonth[section] count];
}
// 2 sections , 1 for Sun ~ Sat , 1 for day cells
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return [cellsInMonth count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if(indexPath.section == 0)
    {
        NSString *weekName = [[cellsInMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell setDayLabelText:weekName];
        [cell.dayLabel setBackgroundColor:[UIColor greenColor]];
    }else{
        NSDate *day = [[[cellsInMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"date"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"d"];
        [cell setDayLabelText:[format stringFromDate:day]];
        
        NSString *inMonth = [[[cellsInMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"inMonth"];
        if([inMonth isEqualToString:@"NO"]){
            [cell.dayLabel setEnabled:FALSE];
        }
    }

    return cell;
}
#pragma mark - UICollectionViewDelegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout

// set sell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(45, 25);
    if(indexPath.section == 0)
    {
        retval = CGSizeMake(45, 25);
    }
    return retval;
}

// set margin
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
// column spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
// line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


@end
