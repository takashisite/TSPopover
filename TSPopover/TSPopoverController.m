//
//  TSPopoverViewController.m
//
//  Created by Saito Takashi on 5/9/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import "TSPopoverController.h"
#import "TSPopoverTouchView.h"
#import "TSPopoverPopoverView.h"
#import <QuartzCore/QuartzCore.h>


#define CORNER_RADIUS 5
#define MARGIN 5
#define OUTER_MARGIN 5
#define TITLE_LABEL_HEIGHT 25
#define ARROW_SIZE 20
#define ARROW_MARGIN 2

@interface TSPopoverController ()

@end

@implementation TSPopoverController

@synthesize contentViewController = _contentViewController;
@synthesize contentView = _contentView;
@synthesize cornerRadius = _cornerRadius;
@synthesize titleText = _titleText;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize arrowPosition = _arrowPosition;
@synthesize popoverBaseColor = _popoverBaseColor;
@synthesize popoverGradient = _popoverGradient;

- (id)init {
	if ((self = [super init])) {
        
        
        self.cornerRadius = CORNER_RADIUS;
        self.titleColor = [UIColor whiteColor];
        self.titleFont = [UIFont boldSystemFontOfSize:14];
        self.view.backgroundColor = [UIColor clearColor];
        self.arrowPosition = TSPopoverArrowPositionVertical;
        self.popoverBaseColor = [UIColor blackColor];
        self.popoverGradient = YES;
        screenRect = [[UIScreen mainScreen] bounds];
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            screenRect.size.width = [[UIScreen mainScreen] bounds].size.height;
            screenRect.size.height = [[UIScreen mainScreen] bounds].size.width;
        }
        self.view.frame = screenRect;
        screenRect.origin.y = 0;
        screenRect.size.height = screenRect.size.height-20;   
        
        titleLabelheight = 0;
	}
	return self;
}

- (id)initWithContentViewController:(UIViewController*)viewController
{
    self = [self init];
    
    self.contentViewController = viewController;
    self.contentView = viewController.view;
    
    return self;
}

- (id)initWithView:(UIView*)view
{
    self = [self init];
    self.contentView = view;
    
    return self;   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) showPopoverWithTouch:(UIEvent*)senderEvent
{    
    UIView *senderView = [[senderEvent.allTouches anyObject] view];
    CGPoint applicationFramePoint = CGPointMake(screenRect.origin.x,0-screenRect.origin.y);
    //CGPoint senderLocationInWindowPoint = [[[UIApplication sharedApplication] keyWindow] convertPoint:applicationFramePoint fromView:senderView];
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint senderLocationInWindowPoint = [appWindow.rootViewController.view convertPoint:applicationFramePoint fromView:senderView];
    CGRect senderFrame = [[[senderEvent.allTouches anyObject] view] frame];
    senderFrame.origin.x = senderLocationInWindowPoint.x;
    senderFrame.origin.y = senderLocationInWindowPoint.y;
    CGPoint senderPoint = [self senderPointFromSenderRect:senderFrame];
    [self showPopoverWithPoint:senderPoint];
}

- (void) showPopoverWithCell:(UITableViewCell*)senderCell
{
    UIView *senderView = senderCell.superview;
    CGPoint applicationFramePoint = CGPointMake(screenRect.origin.x,0-screenRect.origin.y);
    CGPoint senderLocationInWindowPoint = [[[UIApplication sharedApplication] keyWindow] convertPoint:applicationFramePoint fromView:senderView];
    CGRect senderFrame = senderCell.frame;
    senderFrame.origin.x = senderLocationInWindowPoint.x;
    senderFrame.origin.y = senderLocationInWindowPoint.y + senderFrame.origin.y;
    CGPoint senderPoint = [self senderPointFromSenderRect:senderFrame];
    [self showPopoverWithPoint:senderPoint];
}

- (void) showPopoverWithRect:(CGRect)senderRect
{

    CGPoint senderPoint = [self senderPointFromSenderRect:senderRect];
    [self showPopoverWithPoint:senderPoint];
}

- (void) showPopoverWithPoint:(CGPoint)senderPoint
{
    if(self.titleText){
        titleLabelheight = TITLE_LABEL_HEIGHT;
    }
    TSPopoverTouchView *touchView = [[TSPopoverTouchView alloc] init];
    touchView.frame = self.view.frame;
    [touchView setDelegate:self];
    
    [self.view addSubview:touchView];
    CGRect contentViewFrame = [self contentFrameRect:self.contentView.frame senderPoint:senderPoint];
    
    int backgroundPositionX = 0;
    int backgroundPositionY = 0;
    if(arrowDirection == TSPopoverArrowDirectionLeft){
        backgroundPositionX = ARROW_SIZE;
    }
    if(arrowDirection == TSPopoverArrowDirectionTop){
        backgroundPositionY = ARROW_SIZE;
    }
    
    UILabel *titleLabel;
    if(self.titleText){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundPositionX, backgroundPositionY, contentViewFrame.size.width+MARGIN*2, TITLE_LABEL_HEIGHT+MARGIN)];
        titleLabel.textColor = self.titleColor;
        titleLabel.text = self.titleText;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = self.titleFont;
    }
    contentViewFrame.origin.x = backgroundPositionX+MARGIN;
    contentViewFrame.origin.y = backgroundPositionY+titleLabelheight+MARGIN;


    self.contentView.frame = contentViewFrame;
    CALayer * contentViewLayer = [self.contentView layer];
    [contentViewLayer setMasksToBounds:YES];
    [contentViewLayer setCornerRadius:self.cornerRadius];
    
    popoverView = [[TSPopoverPopoverView alloc] init];
    popoverView.arrowDirection = arrowDirection;
    popoverView.arrowPosition = self.arrowPosition;
    popoverView.arrowPoint = senderPoint;
    popoverView.alpha = 0;
    popoverView.frame = [self popoverFrameRect:contentViewFrame senderPoint:senderPoint];
    popoverView.cornerRadius = self.cornerRadius;
    popoverView.baseColor = self.popoverBaseColor;
    popoverView.isGradient = self.popoverGradient;
    [popoverView addSubview:self.contentView];
    [popoverView addSubview:titleLabel];

    CALayer* layer = popoverView.layer;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.5;
    
    [self.view addSubview:popoverView];
    
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    //[appWindow addSubview:self.view];

    [appWindow.rootViewController.view addSubview:self.view];

    
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         popoverView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                     }
     ];

}

- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self dismissPopoverAnimatd:YES];
}


- (void) dismissPopoverAnimatd:(BOOL)animated
{
    if (self.view) {
        if(animated) {
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 popoverView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self.contentViewController viewDidDisappear:animated];
                                 popoverView=nil;
                                 [self.view removeFromSuperview];
                                 self.contentViewController = nil;
                                 self.titleText = nil;
                                 self.titleColor = nil;
                                 self.titleFont = nil;
                             }
             ];
        }else{
            [self.contentViewController viewDidDisappear:animated];
            popoverView=nil;
            [self.view removeFromSuperview];
            self.contentViewController = nil;
            self.titleText = nil;
            self.titleColor = nil;
            self.titleFont = nil;
        }
        
    }
}

- (CGRect) contentFrameRect:(CGRect)contentFrame senderPoint:(CGPoint)senderPoint
{
    CGRect contentFrameRect = contentFrame;
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height - screenRect.origin.y;

    contentFrameRect.origin.x = MARGIN;
    contentFrameRect.origin.y = MARGIN;
    
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;


    if(self.arrowPosition == TSPopoverArrowPositionVertical){
        if(contentFrameRect.size.width > self.view.frame.size.width - (OUTER_MARGIN*2+MARGIN*2)){
            contentFrameRect.size.width = self.view.frame.size.width - (OUTER_MARGIN*2+MARGIN*2);
        }
        
        float popoverY;
        float popoverHeight = contentFrameRect.size.height+titleLabelheight+(ARROW_SIZE+MARGIN*2);
        
        if(arrowDirection == TSPopoverArrowDirectionTop){
            popoverY = senderPoint.y+ARROW_MARGIN;
            if((popoverY+popoverHeight) > screenHeight){
                contentFrameRect.size.height = screenHeight - (screenRect.origin.y + popoverY + titleLabelheight + (OUTER_MARGIN*2+MARGIN*2));
            }
        }
        
        if(arrowDirection == TSPopoverArrowDirectionBottom){
            popoverY = senderPoint.y - ARROW_MARGIN;
            if((popoverY-popoverHeight) < statusBarHeight){
                contentFrameRect.size.height = popoverY - (statusBarHeight + ARROW_SIZE + screenRect.origin.y + titleLabelheight + (OUTER_MARGIN+MARGIN*2));
            }
        }
    }else if(self.arrowPosition == TSPopoverArrowPositionHorizontal){
        if(contentFrameRect.size.height > screenHeight - (OUTER_MARGIN*2+MARGIN*2)){
            contentFrameRect.size.height = screenHeight - (OUTER_MARGIN*2+MARGIN*2);
        }
        
        float popoverX;
        float popoverWidth = contentFrameRect.size.width+(ARROW_SIZE+MARGIN*2);
        
        if(arrowDirection == TSPopoverArrowDirectionLeft){
            popoverX = senderPoint.x + ARROW_MARGIN;
            if((popoverX+popoverWidth)> screenWidth - (OUTER_MARGIN*2+MARGIN*2)){
                contentFrameRect.size.width = screenWidth - popoverX - ARROW_SIZE - (OUTER_MARGIN*2+MARGIN*2);
            }
        }
        
        if(arrowDirection == TSPopoverArrowDirectionRight){
            popoverX = senderPoint.x - ARROW_MARGIN;
            if((popoverX-popoverWidth) < screenRect.origin.x+(OUTER_MARGIN*2+MARGIN*2)){
                contentFrameRect.size.width = popoverX - ARROW_SIZE - (OUTER_MARGIN*2+MARGIN*2);
            }
        }
        
    }
    
    return contentFrameRect;
}


- (CGRect)popoverFrameRect:(CGRect)contentFrame senderPoint:(CGPoint)senderPoint
{
    CGRect popoverRect;
    float popoverWidth;
    float popoverHeight;
    float popoverX;
    float popoverY;

    if(self.arrowPosition == TSPopoverArrowPositionVertical){
        
        popoverWidth = contentFrame.size.width+MARGIN*2;
        popoverHeight = contentFrame.size.height+titleLabelheight+(ARROW_SIZE+MARGIN*2);

        popoverX = senderPoint.x - (popoverWidth/2);
        if(popoverX < OUTER_MARGIN) {
            popoverX = OUTER_MARGIN;
        } else if((popoverX + popoverWidth)>self.view.frame.size.width) {
            popoverX = self.view.frame.size.width - (popoverWidth+OUTER_MARGIN);
        }
        
        if(arrowDirection == TSPopoverArrowDirectionBottom){
            popoverY = senderPoint.y - popoverHeight - ARROW_MARGIN;
        }else{
            popoverY = senderPoint.y + ARROW_MARGIN;
        }
        
        popoverRect = CGRectMake(popoverX, popoverY, popoverWidth, popoverHeight);
        
    }else if(self.arrowPosition == TSPopoverArrowPositionHorizontal){
        
        popoverWidth = contentFrame.size.width+ARROW_SIZE+MARGIN*2;
        popoverHeight = contentFrame.size.height+titleLabelheight+MARGIN*2;

        if(arrowDirection == TSPopoverArrowDirectionRight){
            popoverX = senderPoint.x - popoverWidth - ARROW_MARGIN;
        }else{
            popoverX = senderPoint.x + ARROW_MARGIN;
        }
        
        popoverY = senderPoint.y - (popoverHeight/2);
        if(popoverY < OUTER_MARGIN){
            popoverY = OUTER_MARGIN;
        }else if((popoverY + popoverHeight)>self.view.frame.size.height){
            popoverY = self.view.frame.size.height - (popoverHeight+OUTER_MARGIN);
        }
        
        popoverRect = CGRectMake(popoverX, popoverY, popoverWidth, popoverHeight);

    }


    return popoverRect;
    
}

- (CGPoint)senderPointFromSenderRect:(CGRect)senderRect
{
    CGPoint senderPoint;
    [self checkArrowPosition:senderRect];
    
    if(arrowDirection == TSPopoverArrowDirectionTop){
        senderPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width/2), senderRect.origin.y + senderRect.size.height);
    }else if(arrowDirection == TSPopoverArrowDirectionBottom){
        senderPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width/2), senderRect.origin.y);
    }else if(arrowDirection == TSPopoverArrowDirectionRight){
        senderPoint = CGPointMake(senderRect.origin.x, senderRect.origin.y + (senderRect.size.height/2));
        senderPoint.y = senderPoint.y + screenRect.origin.y;
    }else if(arrowDirection == TSPopoverArrowDirectionLeft){
        senderPoint = CGPointMake(senderRect.origin.x + senderRect.size.width, senderRect.origin.y + (senderRect.size.height/2));
        senderPoint.y = senderPoint.y + screenRect.origin.y;
    }

    return senderPoint;
}

- (void) checkArrowPosition:(CGRect)senderRect
{
    float clearSpaceA=0;
    float clearSpaceB=0;
    if(self.arrowPosition == TSPopoverArrowPositionVertical){
        if(!arrowDirection){
            clearSpaceA = screenRect.origin.y + senderRect.origin.y;
            clearSpaceB = screenRect.size.height - (senderRect.origin.y+senderRect.size.height);
            if(clearSpaceA> clearSpaceB){
                if(clearSpaceA < titleLabelheight+10){
                    self.arrowPosition = TSPopoverArrowPositionHorizontal;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = TSPopoverArrowDirectionBottom;
                }
            }else{
                if(clearSpaceB < titleLabelheight+10){
                    self.arrowPosition = TSPopoverArrowPositionHorizontal;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = TSPopoverArrowDirectionTop;
                }
            }
        }
        
        
    }else if(self.arrowPosition == TSPopoverArrowPositionHorizontal){
        
        if(!arrowDirection){
            clearSpaceA = screenRect.origin.x + senderRect.origin.x;
            clearSpaceB = screenRect.size.width - (senderRect.origin.x+senderRect.size.width);
            if(clearSpaceA> clearSpaceB){
                if(clearSpaceA < 40){
                    self.arrowPosition = TSPopoverArrowPositionVertical;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = TSPopoverArrowDirectionRight;
                }
            }else{
                if(clearSpaceB < 40){
                    self.arrowPosition = TSPopoverArrowPositionVertical;
                    [self checkArrowPosition:senderRect];
                }else{
                    arrowDirection = TSPopoverArrowDirectionLeft;
                }
            }
        }
        
    }
}

@end
