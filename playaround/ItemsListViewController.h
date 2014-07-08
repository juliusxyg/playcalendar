//
//  ItemsListViewController.h
//  playaround
//
//  Created by Yingang Xue on 6/25/14.
//  Copyright (c) 2014 Yingang Xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) UITableView *listView;

@end
