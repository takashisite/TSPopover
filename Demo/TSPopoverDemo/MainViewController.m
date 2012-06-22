//
//  MainViewController.m
//  TSPopoverDemo
//
//  Created by Saito Takashi on 5/9/12.
//  Copyright (c) 2012 synetics ltd. All rights reserved.
//

#import "MainViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"

@implementation MainViewController

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
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBarButtonItem * topRightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showActionSheet:forEvent:)];
    self.navigationItem.leftBarButtonItem = topRightButton;
    self.navigationItem.rightBarButtonItem = topRightButton;
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                target:self
                                                                                action:@selector(showPopover:forEvent:)];
    UIBarButtonItem *spacerButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *addButton2 = [[UIBarButtonItem alloc] initWithTitle:@"TOUCH" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopover:forEvent:)];
    UIBarButtonItem *spacerButton2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *addButton3 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(showPopover:forEvent:)];
    UIBarButtonItem *spacerButton3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    UIBarButtonItem *addButton4 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(showPopover:forEvent:)];
    UIBarButtonItem *spacerButton4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    UIBarButtonItem *addButton5 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(showPopover:forEvent:)];


    self.toolbarItems = [NSArray arrayWithObjects:addButton, spacerButton, addButton2, spacerButton2, addButton3,spacerButton3, addButton4,spacerButton4, addButton5, nil];

    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [topButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    topButton.frame = CGRectMake(10,10, 300, 30);
    [topButton setTitle:@"button" forState:UIControlStateNormal];
    topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:topButton];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.frame = CGRectMake(10,410, 300, 30);
    [bottomButton setTitle:@"button" forState:UIControlStateNormal];
    bottomButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:bottomButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(300,60, 20, 60);
    [rightButton setTitle:@"button" forState:UIControlStateNormal];
    rightButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0,210, 20, 60);
    [leftButton setTitle:@"button" forState:UIControlStateNormal];
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:leftButton];



}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

//-(void)showPopover:(id)sender 
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];

    popoverController.cornerRadius = 5;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
//    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];

}

-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"action sheet"];
    [actionSheet destructiveButtonWithTitle:@"hoge" block:nil];
    [actionSheet addButtonWithTitle:@"hoge1" block:^{
        NSLog(@"pushed hoge1 button");
    }];
    [actionSheet addButtonWithTitle:@"moge2" block:^{
        NSLog(@"pushed hoge2 button");
    }];
    [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
    actionSheet.cornerRadius = 5;
    
    [actionSheet showWithTouch:event];
}

@end
