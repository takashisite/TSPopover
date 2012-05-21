//
//  TSActionSheet.m
//  TSPopoverDemo
//
//  Created by Saito Takashi on 5/21/12.
//  Copyright (c) 2012 ar.ms. All rights reserved.
//

#import "TSActionSheet.h"
#import "TSPopoverController.h"
#import "UIBarButtonItem+WEPopover.h"

#define CORNER_RADIUS 5
#define BORDER 5
#define TITLE_SHADOW_OFFSET   CGSizeMake(0, -1)
#define BUTTON_HEIGHT 35

@implementation TSActionSheet

@synthesize cornerRadius = _cornerRadius;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize popoverBaseColor = _popoverBaseColor;
@synthesize popoverGradient = _popoverGradient;
@synthesize buttonGradient = _buttonGradient;


- (id)initWithTitle:(NSString *)title 
{
    if ((self = [super init]))
    {
        self.frame = CGRectMake(0,0, 200, 300);
        buttonsMutableArray = [[NSMutableArray alloc] init];
        self.cornerRadius = CORNER_RADIUS;
        self.buttonGradient = YES;
        
        popoverController = [[TSPopoverController alloc] init];
        popoverController.titleText = title;
        popoverController.titleColor = [UIColor whiteColor];
        popoverController.titleFont = [UIFont boldSystemFontOfSize:14];
        popoverController.popoverBaseColor = [UIColor blackColor];
        popoverController.popoverGradient = YES;
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title color:(UIColor*)color block:(void (^)())block
{
    [buttonsMutableArray addObject:[NSArray arrayWithObjects:
                                    block ? [block copy] : [NSNull null],
                                    title,
                                    color,
                                    nil]];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:[UIColor grayColor] block:block];
}

- (void)destructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:[UIColor redColor] block:block];
}

- (void)cancelButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:[UIColor blackColor] block:block];
}




//- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
- (void) showWithTouch:(UIEvent*)senderEvent
{
    NSUInteger i = 1;
    NSUInteger buttonHeight = BUTTON_HEIGHT;
    NSUInteger buttonY = BORDER;
    for (NSArray *button in buttonsMutableArray)
    {
        NSString *title = [button objectAtIndex:1];
        UIColor *color = [button objectAtIndex:2];
        
        UIImage *image = [self buttonImage:color];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BORDER, buttonY, self.bounds.size.width-BORDER*2, buttonHeight);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.titleLabel.minimumFontSize = 6;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = UITextAlignmentCenter;
        button.titleLabel.shadowOffset = TITLE_SHADOW_OFFSET;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        buttonY += buttonHeight + BORDER;
        
    }
    CGRect frame = self.frame;
    frame.size.height = buttonY;
    self.frame = frame;

    popoverController.contentView = self;
    popoverController.cornerRadius = self.cornerRadius;
    [popoverController showPopoverWithTouch:senderEvent];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    if (buttonIndex >= 0 && buttonIndex < [buttonsMutableArray count])
    {
        id obj = [[buttonsMutableArray objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    if (animated)
    {
        [popoverController dismissPopoverAnimatd:YES];
        [self removeFromSuperview];
    }
    else
    {
        [popoverController dismissPopoverAnimatd:NO];
        [self removeFromSuperview];
    }
}

#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    /* Run the button's block */
    int buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIImage

-(UIImage*)buttonImage:(UIColor*)color
{
    
    //Size
    float buttonWidth = self.frame.size.width - (BORDER*2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, BUTTON_HEIGHT), NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects: 
                               (id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.3].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.2].CGColor, 
                               (id)[UIColor clearColor].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.1].CGColor, 
                               (id)[UIColor colorWithWhite:1.0 alpha:0.2].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.1, 0.49, 0.5, 0.51, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, buttonWidth, BUTTON_HEIGHT) cornerRadius: self.cornerRadius];
    [color setFill];
    [roundedRectanglePath fill];
    
    
    if(self.buttonGradient){
        //// GradientPath Drawing
        UIBezierPath* gradientPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, buttonWidth, BUTTON_HEIGHT) cornerRadius: self.cornerRadius];
        CGContextSaveGState(context);
        [gradientPath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(buttonWidth/2, 0), CGPointMake(buttonWidth/2, BUTTON_HEIGHT), 0);
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return output;
}

@end
