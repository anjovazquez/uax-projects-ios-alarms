//
//  DetailViewController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 20/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@end



@implementation DetailViewController

@synthesize databasePath;
@synthesize myDatabase;

AppDelegate *delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self.infoDetail setText:[_alarmElement alarmName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateAlarm:(id)sender {
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:
                                     @"sampleDatabase.db"]];
    
    const char *dbpath = [databasePath UTF8String];

    
    sqlite3_stmt    *statement;
    //const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
        NSString *updateSQL = @"UPDATE ALARMS SET ALARM=?  WHERE ID=?";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date = [self.datePicker date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        comps.second = 0;
        NSDate *dateNoSecond = [calendar dateFromComponents:comps];
        NSString *dateString = [dateFormatter stringFromDate:dateNoSecond];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(myDatabase, update_stmt,  -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, _alarmElement.alarmId);
        
        sqlite3_step(statement);
        
        
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message: statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
        
        sqlite3_finalize(statement);
        sqlite3_close(myDatabase);
        
        NSTimer *f = [[NSTimer alloc] initWithFireDate:dateNoSecond
                                              interval:0
                                                target:self
                                              selector:@selector(test)
                                              userInfo:nil repeats:NO];
        [delegate addAlarm:f keyTimer:[NSString stringWithFormat:@"%d", _alarmElement.alarmId]];
        
        
        /*NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:f forMode: NSDefaultRunLoopMode];*/
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)test {
    NSLog(@"timerrrr");
        [delegate alarm];
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
