//
//  ClockNavigationController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 29/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "ClockNavigationController.h"
#import "LandscapeViewController.h"

@interface ClockNavigationController ()

@end

@implementation ClockNavigationController

BOOL isShowingLandscapeView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
- (void)orientationChanged:(NSNotification *)notification
 {
 UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
 if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView)
 {
     LandscapeViewController *landscapeViewController = [[LandscapeViewController alloc] initWithNibName:@"LandscapeViewController" bundle:nil];
     [self setViewControllers:[NSArray arrayWithObject:landscapeViewController] animated:YES];
     isShowingLandscapeView = YES;
 }
 else if (UIDeviceOrientationIsLandscape(deviceOrientation) && isShowingLandscapeView)
 {
 [self dismissViewControllerAnimated:YES completion:nil];
 isShowingLandscapeView = NO;
 }
 }
 
 - (void)awakeFromNib
 {
 isShowingLandscapeView = NO;
 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(orientationChanged:)
 name:UIDeviceOrientationDidChangeNotification
 object:nil];
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
