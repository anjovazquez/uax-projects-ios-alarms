//
//  SettingsView.m
//  AlarmClock
//
//  Created by Angel Vazquez on 24/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "SettingsView.h"
#import <AudioToolbox/AudioToolbox.h>


@interface SettingsView ()

@end

@implementation SettingsView

@synthesize sounds;
SystemSoundID mySoundID;

NSArray *fonts;
NSArray *colors;
NSArray *options;

NSMutableArray *firstSelectedCellsArray;
NSMutableArray *secondSelectedCellsArray;
NSMutableArray *thirdSelectedCellsArray;
NSMutableArray *fourthSelectedCellsArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Cancel button response
    if (buttonIndex == 0) {
        AudioServicesDisposeSystemSoundID(mySoundID);
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    firstSelectedCellsArray= [[NSMutableArray alloc]init];
    secondSelectedCellsArray= [[NSMutableArray alloc]init];
    thirdSelectedCellsArray= [[NSMutableArray alloc]init];
    fourthSelectedCellsArray= [[NSMutableArray alloc]init];
    
    
    
    
    sounds = @[@"Twinkle",@"Waves",@"Hillside",@"Vibrate"];
    options = @[@"Year",@"Month",@"Day"];
    fonts = @[@"Palatino-Bold",@"Papyrus",@"TrebuchetMS-Bold"];
    colors = @[@"Red",@"Blue",@"Green"];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *alarmSound = [standardDefaults stringForKey:@"alarmSound"];
    NSString *fontPref = [standardDefaults stringForKey:@"fontPref"];
    NSString *colorPref = [standardDefaults stringForKey:@"colorPref"];
    NSString *yearAct = [standardDefaults stringForKey:@"Year"];
    NSString *monthAct = [standardDefaults stringForKey:@"Month"];
    NSString *dayAct = [standardDefaults stringForKey:@"Day"];
    
    if(yearAct!=nil){
        [firstSelectedCellsArray addObject:[NSNumber numberWithUnsignedInt:0]];
    }
    if(monthAct!=nil){
        [firstSelectedCellsArray addObject:[NSNumber numberWithUnsignedInt:1]];
    }
    if(dayAct!=nil){
        [firstSelectedCellsArray addObject:[NSNumber numberWithUnsignedInt:2]];
    }
    
    if(fontPref!=nil){
    [secondSelectedCellsArray addObject:[NSNumber numberWithUnsignedInteger:[fonts indexOfObject:fontPref]]];
    }
    if(colorPref!=nil){
    [thirdSelectedCellsArray addObject:[NSNumber numberWithUnsignedInteger:[colors indexOfObject:colorPref]]];
    }
    if(alarmSound!=nil){
        [fourthSelectedCellsArray addObject:[NSNumber numberWithUnsignedInteger:[sounds indexOfObject:alarmSound]]];
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsInSection = 1;
    switch (section) {
        case 0:
            rowsInSection = 3;
            break;
        case 1:
            rowsInSection = 3;
            break;
        case 2:
            rowsInSection = 3;
            break;            
        case 3:
            rowsInSection = 4;
            break;
        default:
            break;
    }
    return rowsInSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section==0)
    {
        NSNumber *rowNsNum = [NSNumber numberWithInteger:indexPath.row];
        cell.textLabel.text = NSLocalizedString([options objectAtIndex:indexPath.row],nil);
        if ( [firstSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if(indexPath.section==1)
    {
        
        NSNumber *rowNsNum = [NSNumber numberWithInteger:indexPath.row];
        cell.textLabel.text = [fonts objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:[fonts objectAtIndex:indexPath.row] size:18];
        if ( [secondSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if(indexPath.section==2)
    {
        
        NSNumber *rowNsNum = [NSNumber numberWithInteger:indexPath.row];
        cell.textLabel.text = NSLocalizedString([colors objectAtIndex:indexPath.row],nil);
        if([[colors objectAtIndex:indexPath.row] isEqualToString:@"Red"]){
            cell.textLabel.textColor = 	[UIColor redColor];
        }
        if([[colors objectAtIndex:indexPath.row] isEqualToString:@"Blue"]){
            cell.textLabel.textColor = 	[UIColor blueColor];
        }
        if([[colors objectAtIndex:indexPath.row] isEqualToString:@"Green"]){
            cell.textLabel.textColor = 	[UIColor greenColor];
        }
        if ( [thirdSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if(indexPath.section==3)
    {
        
        NSNumber *rowNsNum = [NSNumber numberWithInteger:indexPath.row];
        cell.textLabel.text = [sounds objectAtIndex:indexPath.row];
        if ( [fourthSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            [standardDefaults setObject:@"On" forKey:(NSString*)[options objectAtIndex:indexPath.row]];
            [standardDefaults synchronize];
            if ( [firstSelectedCellsArray containsObject:rowNumber]  )
            {
                [firstSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [firstSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            [standardDefaults removeObjectForKey:[options objectAtIndex:indexPath.row]];
            [standardDefaults synchronize];
            if ( [firstSelectedCellsArray containsObject:rowNumber]  )
            {
                [firstSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [firstSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 1)
    {
        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            [standardDefaults setObject:fonts[indexPath.row] forKey:@"fontPref"];
            [standardDefaults synchronize];
            if ( [secondSelectedCellsArray containsObject:rowNumber]  )
            {
                [secondSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [secondSelectedCellsArray removeAllObjects];
                [secondSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if ( [secondSelectedCellsArray containsObject:rowNumber]  )
            {
                [secondSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [secondSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 2)
    {
        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            [standardDefaults setObject:colors[indexPath.row] forKey:@"colorPref"];
            [standardDefaults synchronize];
            if ( [thirdSelectedCellsArray containsObject:rowNumber]  )
            {
                [thirdSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [thirdSelectedCellsArray removeAllObjects];
                [thirdSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if ( [thirdSelectedCellsArray containsObject:rowNumber]  )
            {
                [thirdSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [thirdSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 3)
    {
        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            if(![@"Vibrate" isEqualToString:sounds[indexPath.row]]){
                NSString *path = [[NSBundle mainBundle]pathForResource:sounds[indexPath.row] ofType:@"m4r"];
                NSURL *url = [NSURL fileURLWithPath:path];
                
                OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mySoundID);
                NSLog(@"AudioServicesCreateSystemSoundID status = %d", (int)(int)status);
                AudioServicesPlayAlertSound(mySoundID);
            }
            else{
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sound",nil) message:NSLocalizedString(@"Sound Picked",nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertView show];
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            [standardDefaults setObject:sounds[indexPath.row] forKey:@"alarmSound"];
            [standardDefaults synchronize];
            if ( [fourthSelectedCellsArray containsObject:rowNumber]  )
            {
                [fourthSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [fourthSelectedCellsArray removeAllObjects];
                [fourthSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if ( [fourthSelectedCellsArray containsObject:rowNumber]  )
            {
                [fourthSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [fourthSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    [tableView reloadData];

    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
