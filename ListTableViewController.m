//
//  ListTableViewController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 17/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "ListTableViewController.h"
#import "DetailViewController.h"
#import "AlarmElement.h"
#import "AppDelegate.h"

@interface ListTableViewController ()
@property (strong, nonatomic) UIStoryboardPopoverSegue* popSegue;
@end

@implementation ListTableViewController

@synthesize list; //Implementation Section
@synthesize databasePath;
@synthesize myDatabase;

AppDelegate *delegate;

- (void)getTextFomDB {
    NSString *docsDir;
    NSArray *dirPaths;
    
    list = [[NSMutableArray alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:
                                     @"sampleDatabase.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK)
    {
        //Select all from SAMPLETABLE. This includes the 'id' column and 'message' column.
        NSString *querySQL = @"SELECT * FROM ALARMS";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            [list removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int alarmId = sqlite3_column_int(statement, 0);
                NSString *text = [[NSString alloc]
                                  initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]; //Num 1 means on what column. Column 0 = 'id' column while sColumn 1 = 'message' column in our query result.
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];//Z
                NSDate *alarmDate = [dateFormatter dateFromString:text];
                
                NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
                [outFormat setDateFormat: @"HH:mm"];
                
                
                AlarmElement *element = [[AlarmElement alloc] init];
                [element setAlarmName:[outFormat stringFromDate:alarmDate]];
                [element setAlarmId:alarmId];
                
                [list addObject:element];
                
                NSLog(@"count: %tu", [list count]);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self getTextFomDB];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getTextFomDB];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.,
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    AlarmElement *element = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = [element alarmName];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
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
        
        if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK)
        {
            
            AlarmElement *element = [list objectAtIndex:indexPath.row];
            NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM ALARMS WHERE ID=%d", element.alarmId];
            //Select all from SAMPLETABLE. This includes the 'id' column and 'message' column.
            const char *delete_stmt = [deleteSQL UTF8String];
            
            
            sqlite3_prepare_v2(myDatabase, delete_stmt, -1, &statement, NULL);
            sqlite3_step(statement);
            
            [delegate deleteAlarm:[NSString stringWithFormat:@"%d", element.alarmId]];
            
            sqlite3_finalize(statement);
            sqlite3_close(myDatabase);
        }
        
        [list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller 	using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    AlarmElement *alarm = [list objectAtIndex:indexPath.row];
    
    [detailViewController setAlarmElement:alarm];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{    
    [self getTextFomDB];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"popover"])
    {
        //NSLog(@"%@",[[segue destinationViewController] viewControllers]);
        self.popSegue = (UIStoryboardPopoverSegue*)segue;
        [self.popSegue.popoverController setDelegate:self];
    }
}


@end
