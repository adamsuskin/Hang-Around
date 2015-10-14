//
//  ANSMainViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 7/1/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "ANSStatusViewController.h"
#import "ANSServerHandler.h"
#import "ANSSessionHandler.h"
#import "ANSQueryTableViewController.h"
#import "ANSOptionsViewController.h"
#import "ANSButton.h"

@interface ANSMainViewController : UIViewController

@property (strong, nonatomic) ANSServerHandler *haServerHandler;
@property (strong, nonatomic) ANSStatusViewController *haStatusViewController;
@property (strong, nonatomic) ANSQueryTableViewController *haQueryTableViewController;
@property (strong, nonatomic) ANSOptionsViewController *haOptionsViewController;
@property (strong, nonatomic) UIView *haMenuView;
@property (strong, nonatomic) UIView *haMenuContentView;
@property (strong, nonatomic) UIView *haBackgroundTint;
@property (strong, nonatomic) NSArray *data;

-(void)refreshData;
-(id)initWithFrame:(CGRect)frame;
@end
