//
//  TabBarViewController.m
//  AlarmClock
//
//  Created by Angel Vazquez on 20/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}
	
- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger index = [self selectedIndex];
    
    //[self.tabBarController setSelectedIndex:selectedIndex + 1];
    //self.tabBarController.selectedIndex = 1;
    //[(UITabBarController*)self.tabBarController.navigationController setSelectedIndex:1];
    self.selectedIndex = index + 1;
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger index = [self selectedIndex];
    self.selectedIndex = index - 1;
    //self.tabBarController.view = [self.tabBarController.viewControllers objectAtIndex:0];
    //[self.tabBarController setSelectedIndex:selectedIndex - 1];
    //[(UITabBarController*)self.tabBarController.navigationController setSelectedIndex:0];
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
