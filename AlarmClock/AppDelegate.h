//
//  AppDelegate.h
//  AlarmClock
//
//  Created by Angel Vazquez on 10/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)  NSString *databasePath;
@property (nonatomic)  sqlite3 *myDatabase;

@property NSMutableDictionary *cachedAlarms;

-(void)alarm;

-(void)addAlarm:(NSTimer *)timer keyTimer:(NSString*)key;

-(void)deleteAlarm:(NSString*)key;

@end
