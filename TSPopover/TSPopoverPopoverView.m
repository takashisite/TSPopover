//
//  TSPopoverPopoverView.m
//
//  Created by Saito Takashi on 5/10/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//
// https://github.com/takashisite/TSPopover
//

#import "TSPopoverPopoverView.h"

#define MARGIN 5
#define ARROW_SIZE 20

@implementation TSPopoverPopoverView

@synthesize cornerRadius = _cornerRadius;
@synthesize arrowPoint = _arrowPoint;
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowPosition = _arrowPosition;
@synthesize baseColor = _baseColor;
@synthesize isGradient = _isGradient;

- (id)init
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.baseColor = [UIColor blackColor];
        self.isGradient = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    UIImage *backgroundImage = self.backgroundImage;
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
    
}

-(UIImage*)backgroundImage
{
    //// Color
    CGFloat myRed=0,myGreen=0,myBlue=0,myWhite=0,alpha=1;
    UIColor *gradientBaseColor = self.baseColor;
    UIColor* gradientTopColor;
    UIColor* gradientMiddleColor;
    UIColor* gradientBottomColor;
    
    BOOL s = [gradientBaseColor getRed:&myRed green:&myGreen blue:&myBlue alpha:&alpha ];
    if(!s) {
        [gradientBaseColor getWhite:&myWhite alpha:&alpha];
    }

    if(myRed < 0) myRed = 0;
    if(myGreen < 0) myGreen = 0;
    if(myBlue < 0) myBlue = 0;
    if(myWhite < 0) myWhite = 0;
    
    if(myWhite > 0.0f){
        gradientTopColor = [UIColor colorWithWhite:myWhite+0.35f alpha:1];
        gradientMiddleColor = [UIColor colorWithWhite:myWhite+0.13f alpha:1];
        gradientBottomColor = [UIColor colorWithWhite:myWhite alpha:1];
    } else {
        gradientTopColor = [UIColor colorWithRed:myRed+0.35f green:myGreen+0.35f blue:myBlue+0.35f alpha: 1];
        gradientMiddleColor = [UIColor colorWithRed:myRed+0.13f green:myGreen+0.13f blue:myBlue+0.13f alpha: 1];
        gradientBottomColor = [UIColor colorWithRed:myRed green:myGreen blue:myBlue alpha: 1];
    }
    
    UIColor *arrowColor = gradientBottomColor;
    if(self.arrowDirection == TSPopoverArrowDirectionTop && self.isGradient){
        arrowColor = gradientTopColor;
    }
    
    //size
    float bgSizeWidth = self.frame.size.width;
    float bgSizeHeight = self.frame.size.height;
    float bgRectSizeWidth = 0;
    float bgRectSizeHeight = 0;
    float bgRectPositionX = 0;
    float bgRectPositionY = 0;
    float arrowHead = 0;
    float arrowBase = ARROW_SIZE+1;
    float arrowFirst =0;
    float arrowLast = 0;
    
    //CGPoint senderLocationInViewPoint = [self convertPoint:self.arrowPoint fromView:[[UIApplication sharedApplication] keyWindow]];
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint senderLocationInViewPoint = [self convertPoint:self.arrowPoint fromView:appWindow.rootViewController.view];

    if(self.arrowPosition == TSPopoverArrowPositionVertical){
        bgRectSizeWidth = bgSizeWidth;
        bgRectSizeHeight = bgSizeHeight - ARROW_SIZE;
        
        if(self.arrowDirection == TSPopoverArrowDirectionTop){
            bgRectPositionY = ARROW_SIZE;
        }
        
        if(self.arrowDirection == TSPopoverArrowDirectionBottom){
            arrowHead = bgRectSizeHeight + ARROW_SIZE;
            arrowBase = bgRectSizeHeight - 1;
        }
    }else if(self.arrowPosition == TSPopoverArrowPositionHorizontal){
        bgRectSizeWidth = bgSizeWidth - ARROW_SIZE;
        bgRectSizeHeight = bgSizeHeight;
        
        if(self.arrowDirection == TSPopoverArrowDirectionLeft){
            bgRectPositionX = ARROW_SIZE;
        }
        
        if(self.arrowDirection == TSPopoverArrowDirectionRight){
            arrowHead = bgRectSizeWidth + ARROW_SIZE;
            arrowBase = bgRectSizeWidth - 1;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgSizeWidth, bgSizeHeight), NO, 0);

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    
    //// Gradient Declarations
    NSArray* bgGradientColors = [NSArray arrayWithObjects: 
                                 (id)gradientBottomColor.CGColor, 
                                 (id)gradientBottomColor.CGColor, 
                                 (id)gradientMiddleColor.CGColor, 
                                 (id)gradientTopColor.CGColor, nil];
    CGFloat bgGradientLocations[] = {0,0.4, 0.5, 1};
    CGGradientRef bgGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)bgGradientColors, bgGradientLocations);
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(bgRectPositionX, bgRectPositionY, bgRectSizeWidth, bgRectSizeHeight) cornerRadius: self.cornerRadius+MARGIN];

    
    //// Polygon Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    if(self.arrowPosition == TSPopoverArrowPositionVertical){
        arrowFirst = senderLocationInViewPoint.x-ARROW_SIZE/2;
        arrowLast = senderLocationInViewPoint.x+ARROW_SIZE/2;
        if(arrowFirst < bgRectPositionX + (self.cornerRadius+MARGIN)){
            arrowFirst = bgRectPositionX + (self.cornerRadius+MARGIN);
            arrowLast = arrowFirst + ARROW_SIZE;
        }
        if(arrowLast > (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius+MARGIN)){
            arrowLast = (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius+MARGIN);
            arrowFirst = arrowLast -  ARROW_SIZE;
        }
        [bezierPath moveToPoint: CGPointMake(arrowFirst, arrowBase)];
        [bezierPath addLineToPoint: CGPointMake(senderLocationInViewPoint.x, arrowHead)];
        [bezierPath addLineToPoint: CGPointMake(arrowLast, arrowBase)];
    }else if(self.arrowPosition == TSPopoverArrowPositionHorizontal){
        arrowFirst = senderLocationInViewPoint.y-ARROW_SIZE/2;
        arrowLast = senderLocationInViewPoint.y+ARROW_SIZE/2;
        
        if(arrowFirst < bgRectPositionY + (self.cornerRadius+MARGIN)){
            arrowFirst = bgRectPositionY + (self.cornerRadius+MARGIN);
            arrowLast = arrowFirst + ARROW_SIZE;
        }

        if(arrowLast > (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius+MARGIN)){
            arrowLast = (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius+MARGIN);
            arrowFirst = arrowLast - ARROW_SIZE;
        }

        [bezierPath moveToPoint: CGPointMake(arrowBase, arrowFirst)];
        [bezierPath addLineToPoint: CGPointMake(arrowHead, senderLocationInViewPoint.y)];
        [bezierPath addLineToPoint: CGPointMake(arrowBase, arrowLast)];
    }

    CGContextSaveGState(context);
    [arrowColor setFill];
    [bezierPath fill];
    [roundedRectanglePath appendPath:bezierPath];

    [roundedRectanglePath addClip];  
    
    [gradientBottomColor setFill];
    [roundedRectanglePath fill];
    if(self.arrowDirection == TSPopoverArrowDirectionTop){
        [arrowColor setFill];
        [bezierPath fill];
    }
    if(self.isGradient){
        CGContextDrawLinearGradient(context, bgGradient, CGPointMake(0, bgRectPositionY+20), CGPointMake(0, bgRectPositionY), 0);
    }
    
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(bgGradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    return output;
}

@end
