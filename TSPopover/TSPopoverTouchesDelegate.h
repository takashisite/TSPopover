//
//  TSPopoverTouchDelegate.h
//
//  Created by Saito Takashi on 5/9/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import <UIKit/UIKit.h>


@protocol TSPopoverTouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end