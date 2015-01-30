//
//  UIWindow+Shake.m
//  AlarmClock
//
//  Created by Angel Vazquez on 26/06/14.
//  Copyright (c) 2014 uax. All rights reserved.
//

#import "UIWindow+Shake.h"

@implementation UIWindow (Shake)


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIWindowDidShake" object:nil userInfo:nil];
    }
}

@end
