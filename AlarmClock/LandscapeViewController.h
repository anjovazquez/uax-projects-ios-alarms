//
//  ViewController.h
//  AlarmClock
//
//  Created by Angel Vazquez on 10/05/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandscapeViewController : UIViewController {
    IBOutlet UILabel *label;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *secLabel;
    NSTimer *timer;
    
}

-(void)Actualizar;

@end
