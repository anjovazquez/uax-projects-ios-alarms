//
//  DetailViewController.h
//  AlarmClock
//
//  Created by Angel Vazquez on 20/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AlarmElement.h"
@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *infoDetail;
@property (weak, nonatomic) AlarmElement *alarmElement;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic)  NSString *databasePath;
@property (nonatomic)  sqlite3 *myDatabase;

- (IBAction)updateAlarm:(id)sender;

@end
