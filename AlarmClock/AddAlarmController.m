//
//  AddAlarmController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 11/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "AddAlarmController.h"
#import "AppDelegate.h"

@interface AddAlarmController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *bSetAlarm;
@end

@implementation AddAlarmController

@synthesize databasePath;
@synthesize myDatabase;

AppDelegate *delegate;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_bSetAlarm setTitle:NSLocalizedString(@"SetAlarm",nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    NSLog(@"timerrrr");
    
    [delegate alarm];
}

- (IBAction)setAlarm:(id)sender{
    
    
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"sampleDatabase.db"]];
    //NSLog(@"DB Path: %@", databasePath);
    
    NSString *statusOfAddingToDB;
    
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    
    NSDate *date = [self.datePicker date];
    NSDate *now = [NSDate date];
    if ([now compare:date] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BadProgrammedAlarm",nil) message: statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        comps.second = 0;
        NSDate *dateNoSecond = [calendar dateFromComponents:comps];
        NSString *dateString = [formatter stringFromDate:dateNoSecond];
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO ALARMS (ALARM) VALUES (\"%@\")",
                               dateString];
        
        const char*insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myDatabase, insert_stmt,  -1, &statement, NULL);
        int result = sqlite3_step(statement);
        NSLog(@"Result code %d",result);
        if (result == SQLITE_DONE) {
            statusOfAddingToDB = [NSString stringWithFormat:NSLocalizedString(@"Alarm added -- %@", fdate)];
            NSNumber *alarmID = [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(myDatabase)];
            //int alarmID = sqlite3_last_insert_rowid(myDatabase);
            NSTimer *f = [[NSTimer alloc] initWithFireDate:dateNoSecond
                                                  interval:0
                                                    target:self
                                                  selector:@selector(test)
                                                  userInfo:nil repeats:NO];
            [delegate addAlarm:f keyTimer:[NSString stringWithFormat:@"%d", [alarmID integerValue]]];
            
        } else {
            statusOfAddingToDB = @"Error adding alarm";
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alarm Programmed",nil) message: statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(myDatabase);
        
        /*NSTimer *f = [[NSTimer alloc] initWithFireDate:dateNoSecond
                                              interval:0
                                                target:self
                                              selector:@selector(test)
                                              userInfo:nil repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:f forMode: NSDefaultRunLoopMode];*/
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
