//
//  ViewController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 10/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "LandscapeViewController.h"

@interface LandscapeViewController ()

@end

@implementation LandscapeViewController

    BOOL isShowingPortraitView;

-(void) Actualizar{
    NSDateFormatter *formato = [[NSDateFormatter alloc]init];
    [formato setDateFormat:@"HH:mm"];
    label.text = [formato stringFromDate:[NSDate date]];
    
    NSDateFormatter *fMonth = [[NSDateFormatter alloc]init];
    [fMonth setDateFormat:@"MMM"];
    
    NSDateFormatter *fYear = [[NSDateFormatter alloc]init];
    [fYear setDateFormat:@"yyyy"];
    
    NSDateFormatter *fDay = [[NSDateFormatter alloc]init];
    [fDay setDateFormat:@"EEE d"];
    
    NSDateFormatter *fSec = [[NSDateFormatter alloc]init];
    [fSec setDateFormat:@"ss"];
    
    monthLabel.text = [fMonth stringFromDate:[NSDate date]];
    
    yearLabel.text = [fYear stringFromDate:[NSDate date]];
    
    dayLabel.text = [fDay stringFromDate:[NSDate date]];
    
    secLabel.text = [fSec stringFromDate:[NSDate date]];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if([[standardDefaults stringForKey:@"Year"] isEqualToString:@"On"]){
        yearLabel.hidden = false;
    }
    else{
        yearLabel.hidden = true;
    }
    if([[standardDefaults stringForKey:@"Month"] isEqualToString:@"On"]){
        monthLabel.hidden = false;
    }
    else{
        monthLabel.hidden = true;
    }
    if([[standardDefaults stringForKey:@"Day"] isEqualToString:@"On"]){
        dayLabel.hidden = false;
    }
    else{
        dayLabel.hidden = true;
    }
    
    if([standardDefaults stringForKey:@"colorPref"]!=nil){
        UIColor *color;
        if([[standardDefaults stringForKey:@"colorPref"] isEqualToString:@"Red"]){
            color = [UIColor redColor];
        }
        if([[standardDefaults stringForKey:@"colorPref"] isEqualToString:@"Green"]){
            color = [UIColor greenColor];
        }
        if([[standardDefaults stringForKey:@"colorPref"] isEqualToString:@"Blue"]){
            color = [UIColor blueColor];
        }
        yearLabel.textColor = color;
        monthLabel.textColor = color;
        dayLabel.textColor = color;
        label.textColor = color;
        secLabel.textColor = color;
    }
    if([standardDefaults stringForKey:@"fontPref"]!=nil){
        [yearLabel setFont:[UIFont fontWithName:[standardDefaults stringForKey:@"fontPref"] size:[[yearLabel font] pointSize]]];
        [monthLabel setFont:[UIFont fontWithName:[standardDefaults stringForKey:@"fontPref"] size:[[monthLabel font] pointSize]]];
        [dayLabel setFont:[UIFont fontWithName:[standardDefaults stringForKey:@"fontPref"] size:[[dayLabel font] pointSize]]];
        [label setFont:[UIFont fontWithName:[standardDefaults stringForKey:@"fontPref"] size:[[label font] pointSize]]];
        [secLabel setFont:[UIFont fontWithName:[standardDefaults stringForKey:@"fontPref"] size:[[secLabel font] pointSize]]];
    }
    
    
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(Actualizar) userInfo:nil repeats:YES];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
        !isShowingPortraitView)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        isShowingPortraitView = YES;
    }
}

- (void)awakeFromNib
{
    isShowingPortraitView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
