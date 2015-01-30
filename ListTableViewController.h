//
//  ListTableViewController.h
//  AlarmClock
//
//  Created by Angel Vazquez on 17/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ListTableViewController : UITableViewController<UIPopoverControllerDelegate>

@property (strong, nonatomic)  NSString *databasePath;
@property (nonatomic)  sqlite3 *myDatabase;

@property (strong, nonatomic) NSMutableArray *list; //Interface Section


@end
