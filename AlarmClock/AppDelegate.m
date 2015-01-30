//
//  AppDelegate.m
//  AlarmClock
//
//  Created by Angel Vazquez on 10/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate

SystemSoundID mySoundID;
UIAlertView *alertView;

@synthesize databasePath;
@synthesize myDatabase;
@synthesize cachedAlarms;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    cachedAlarms = [[NSMutableDictionary alloc] init];
    [self prepareDatabase];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if([standardDefaults objectForKey:@"fontPref"]==nil){
        [standardDefaults setObject:@"Papyrus" forKey:@"fontPref"];
    }
    if([standardDefaults objectForKey:@"colorPref"]==nil){
        [standardDefaults setObject:@"Blue" forKey:@"colorPref"];
    }
    if([standardDefaults objectForKey:@"alarmSound"]==nil){
        [standardDefaults setObject:@"Waves" forKey:@"alarmSound"];
    }
    [standardDefaults synchronize];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
    [self deleteAlarms];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UILocalNotification *)application 	:(UILocalNotification *)notification
{
    /*/Users/angelvazquez/Library/Application Support/iPhone Simulator/7.1/Applica	tions/7AD4C49E-8F0A-4358-A72F-29F4B503AAEE/AlarmClock.app/ */
    
}

-(void)deleteAlarms{
    NSEnumerator *en = [cachedAlarms keyEnumerator];
    id key = nil;
    while((key=[en nextObject])!=nil){
        NSTimer *al = [cachedAlarms objectForKey:key];
        [al invalidate];
    }
}

- (void)addAlarm:(NSTimer *)timer keyTimer:(NSString*)key{
    if([cachedAlarms objectForKey:key]){
        NSTimer *al = [cachedAlarms objectForKey:key];
        [al invalidate];
        [cachedAlarms setValue:timer forKey:key];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
    }
    else{
        [cachedAlarms setValue:timer forKey:key];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
    }
}

-(void)deleteAlarm:(NSString*)key{
    if([cachedAlarms objectForKey:key]){
        NSTimer *al = [cachedAlarms objectForKey:key];
        [al invalidate];
        [cachedAlarms removeObjectForKey:key];
    }
}

- (void)alarm
{
    NSLog(@"didReceiveLocalNotification");
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString* alarmSound = [standardDefaults stringForKey:@"alarmSound"];
    
    if(![@"Vibrate" isEqualToString:alarmSound]){
        NSString *path = [[NSBundle mainBundle]pathForResource:alarmSound ofType:@"m4r"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mySoundID);
        NSLog(@"AudioServicesCreateSystemSoundID status = %d", (int)(int)status);
        AudioServicesPlayAlertSound(mySoundID);
    }
    else{
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
    
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alarm",nil) message:NSLocalizedString(@"Switch off Alarm",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Yes",nil) otherButtonTitles:nil, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlert) name:@"UIWindowDidShake" object:nil];
    [alertView show];
}

- (void)dismissAlert {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    AudioServicesDisposeSystemSoundID(mySoundID);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        AudioServicesDisposeSystemSoundID(mySoundID);
    }
}

- (void)prepareDatabase {
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"sampleDatabase.db"]];
    //NSLog(@"DB Path: %@", databasePath);ase.db"]];
    
    NSString *statusOfAddingToDB;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ALARMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ALARM DATETIME)";
            
            if (sqlite3_exec(myDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                statusOfAddingToDB = @"Failed to create table";
                printf("\n%s",errMsg);
                sqlite3_free(errMsg);
            } else {
                statusOfAddingToDB = @"Success in creating table";
            }
            NSLog(@"%@",statusOfAddingToDB);
            sqlite3_close(myDatabase);
        } else {
            statusOfAddingToDB = @"Failed to open/create database";
            NSLog(@"%@",statusOfAddingToDB);
        }
    }
    else{
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK)
        {
            //Select all from SAMPLETABLE. This includes the 'id' column and 'message' column.
            NSString *querySQL = @"SELECT * FROM ALARMS";
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int alarmId = sqlite3_column_int(statement, 0);
                    NSString *text = [[NSString alloc]
                                      initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]; //Num 1 means on what column. Column 0 = 'id' column while sColumn 1 = 'message' column in our query result.
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];//Z
                    NSDate *alarmDate = [dateFormatter dateFromString:text];
                    NSDate *nowDate = [NSDate date];
                    if([alarmDate compare:nowDate]== NSOrderedDescending){
                        NSTimer *f = [[NSTimer alloc] initWithFireDate:alarmDate
                                                              interval:0
                                                                target:self
                                                              selector:@selector(alarm)
                                                              userInfo:nil repeats:NO];
                        [self addAlarm:f keyTimer:[NSString stringWithFormat:@"%d", alarmId]];
                    }
                    
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(myDatabase);
        }
    }
}



@end
