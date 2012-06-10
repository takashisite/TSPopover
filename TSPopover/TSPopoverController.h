//
//  TSPopoverViewController.h
//
//  Created by Saito Takashi on 5/9/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import <UIKit/UIKit.h>
#import "TSPopoverTouchesDelegate.h"

enum {
    TSPopoverArrowDirectionTop = 0,
	TSPopoverArrowDirectionRight,
    TSPopoverArrowDirectionBottom,
    TSPopoverArrowDirectionLeft
};
typedef NSUInteger TSPopoverArrowDirection;

enum {
    TSPopoverArrowPositionVertical = 0,
    TSPopoverArrowPositionHorizontal
};
typedef NSUInteger TSPopoverArrowPosition;

@class TSPopoverPopoverView;

@interface TSPopoverController : UIViewController <TSPopoverTouchesDelegate>
{
    TSPopoverPopoverView * popoverView;
    TSPopoverArrowDirection arrowDirection;
    CGRect screenRect;
    int titleLabelheight;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic) int cornerRadius;
@property (nonatomic, readwrite) TSPopoverArrowPosition arrowPosition;
@property (nonatomic) BOOL popoverGradient; 

- (id)initWithContentViewController:(UIViewController*)viewController;
- (id)initWithView:(UIView*)view;
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;
- (void) showPopoverWithCell:(UITableViewCell*)senderCell;
- (void) showPopoverWithRect:(CGRect)senderRect;
- (void) view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) dismissPopoverAnimatd:(BOOL)animated;

@end
