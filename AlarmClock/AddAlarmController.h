//
//  AddAlarmController.h
//  AlarmClock
//
//  Created by Angel Vazquez on 11/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AddAlarmController : UIViewController

@property (strong, nonatomic)  NSString *databasePath;
@property (nonatomic)  sqlite3 *myDatabase;

- (IBAction)setAlarm:(id)sender;


@end
