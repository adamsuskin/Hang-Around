//
//  ANSViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 6/30/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANSMainViewController.h"
#import "ANSServerHandler.h"
#import "ANSServerHandler.h"
#import "ANSSessionHandler.h"

@interface ANSViewController : UIViewController

@property (strong, nonatomic) ANSMainViewController* haMainViewController;
@property (strong, nonatomic) ANSServerHandler *haServerHandler;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIActivityIndicatorView *haLoginActivityIndicator;
-(IBAction)logInButtonPushed:(id)sender;

@end
