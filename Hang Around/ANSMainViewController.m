//
//  ANSMainViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 7/1/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSMainViewController.h"

@interface ANSMainViewController ()

@end

@implementation ANSMainViewController
@synthesize haStatusViewController, haMenuView, haMenuContentView, data, haBackgroundTint;
@synthesize haServerHandler, haQueryTableViewController, haOptionsViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:frame];
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        UIBarButtonItem *barBtnItm = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"menuBarButtonItemImage.png"]
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(toggleMenu)];
        [barBtnItm setWidth:10.0];
        [[self navigationItem] setRightBarButtonItem:barBtnItm];
        
        UIBarButtonItem *refreshBarBtnItm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
        [[self navigationItem] setLeftBarButtonItem:refreshBarBtnItm];
        
        haQueryTableViewController = [[ANSQueryTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [[haQueryTableViewController view] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
        [[self view] addSubview:[haQueryTableViewController view]];
        
        //Status View Stuff
        haStatusViewController = [[ANSStatusViewController alloc] initWithFrame:self.view.frame];
        [[haStatusViewController statusView] setSelectedIndex:[[[PFUser currentUser] objectForKey:@"state"] intValue]];
        [[haStatusViewController statusView] updateView]; 
        [[self view] addSubview:[haStatusViewController view]];
        
        //Menu View Stuff
        haMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [haMenuView setBackgroundColor:[UIColor clearColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBackgroundTint) name:@"com.adamsuskin.hangaround.toggleBackgroundTint" object:nil];
        
        [self createBackgroundTint];
        [self createContentView];
        
        [haMenuView setHidden:YES];
        [[self view] addSubview:haMenuView];
        
        haOptionsViewController = [[ANSOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [haOptionsViewController setTitle:@"Options"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)toggleBackgroundTint
{
    if([haBackgroundTint isHidden]){
        [haBackgroundTint setHidden:NO];
        [[haBackgroundTint layer] setOpacity:1.0];
        [[haBackgroundTint layer] addAnimation:[self fadeInAnimation:0.2] forKey:nil];
        [[[self navigationItem] leftBarButtonItem] setEnabled:NO];
        [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    }
    else{
        [[[self navigationItem] leftBarButtonItem] setEnabled:YES];
        [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
        [[haBackgroundTint layer] setOpacity:0.0];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [haBackgroundTint setHidden:YES];
        }];
        [[haBackgroundTint layer] addAnimation:[self fadeOutAnimation:0.2] forKey:nil];
        [CATransaction commit];
    }
}

-(void)refreshData
{
    data = [[self haQueryTableViewController] objects];
    [haOptionsViewController setFriends:data];
}

-(void)createBackgroundTint
{
    haBackgroundTint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [haBackgroundTint setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [haBackgroundTint setHidden:YES];
    [[self view] insertSubview:haBackgroundTint aboveSubview:[haQueryTableViewController tableView]];
}

-(void)createContentView
{
    haMenuContentView = [[UIView alloc] initWithFrame:CGRectMake(haMenuView.frame.size.width/8, haMenuView.frame.size.height/8-25, 6*haMenuView.frame.size.width/8, 6*haMenuView.frame.size.height/8)];
    [haMenuContentView setBackgroundColor:[UIColor whiteColor]];
    [[haMenuContentView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[haMenuContentView layer] setShadowOpacity:0.4];
    [[haMenuContentView layer] setShadowRadius:5];
    [[haMenuContentView layer] setShadowOffset:CGSizeMake(0.0, 0.0)];
    [[haMenuContentView layer] setCornerRadius:10.0];
    [[haMenuContentView layer] setBorderColor:[UIColor blackColor].CGColor];
    [[haMenuContentView layer] setBorderWidth:1.0];
    [self createButtonsForContentView];
    
    [haMenuView addSubview:haMenuContentView];
}

-(void)createButtonsForContentView
{
    CGRect contentFrame = haMenuContentView.frame;
    
    UIButton *returnButton = [[ANSButton alloc] initWithFrame:CGRectMake(contentFrame.size.width / 8, contentFrame.size.height / 9, 6 * contentFrame.size.width / 8, contentFrame.size.height / 9)];
    [returnButton addTarget:self
                     action:@selector(handleReturn)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setTitle:@"Dismiss Menu" forState:UIControlStateNormal];
    [haMenuContentView addSubview:returnButton];
    
    UIButton *settingsButton = [[ANSButton alloc] initWithFrame:CGRectMake(contentFrame.size.width / 8, 3*contentFrame.size.height / 9, 6 * contentFrame.size.width / 8, contentFrame.size.height / 9)];
    [settingsButton addTarget:self
                     action:@selector(handleSettings)
           forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setTitle:@"Options" forState:UIControlStateNormal];
    [haMenuContentView addSubview:settingsButton];
    
    UIButton *helpButton = [[ANSButton alloc] initWithFrame:CGRectMake(contentFrame.size.width / 8, 5*contentFrame.size.height / 9, 6 * contentFrame.size.width / 8, contentFrame.size.height / 9)];
    [helpButton addTarget:self
                         action:@selector(handleHelp)
               forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:@"Take the Tour" forState:UIControlStateNormal];
    [haMenuContentView addSubview:helpButton];
    
    UIButton *logOutButton = [[ANSButton alloc] initWithFrame:CGRectMake(contentFrame.size.width / 8, 7*contentFrame.size.height / 9, 6 * contentFrame.size.width / 8, contentFrame.size.height / 9)];
    [logOutButton addTarget:self
               action:@selector(handleLogOut)
     forControlEvents:UIControlEventTouchUpInside];
    [logOutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [haMenuContentView addSubview:logOutButton];
}

-(void)toggleMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.adamsuskin.hangaround.toggleBackgroundTint" object:nil];
    if([haMenuView isHidden]){
        [self presentMenu];
    }
    else {
        [self dismissMenu];
    }
}

-(void)presentMenu
{
    [haMenuView setHidden:NO];
    [[haMenuView layer] setOpacity:1.0];
    [[haMenuView layer] addAnimation:[self fadeInAnimation:0.25] forKey:nil];
}

-(void)dismissMenu
{
    [[haMenuView layer] setOpacity:0.0];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [haMenuView setHidden:YES];
    }];
    [[haMenuView layer] addAnimation:[self fadeOutAnimation:0.2] forKey:nil];
    [CATransaction commit];
}

-(void)handleReturn
{
    [self toggleMenu];
}

-(void)handleSettings
{
    [haOptionsViewController initializeSettings];
    [[self navigationController] pushViewController:haOptionsViewController animated:YES];
}

-(void)handleHelp
{
    
}

-(void)handleLogOut
{
    [PFUser logOut];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(CAAnimation *)fadeOutAnimation:(CFTimeInterval)duration
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = duration;
    return fadeAnim;
}

-(CAAnimation *)fadeInAnimation:(CFTimeInterval)duration
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = duration;
    return fadeAnim;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
