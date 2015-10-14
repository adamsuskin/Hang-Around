//
//  ANSOptionsViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 7/22/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANSSessionHandler.h"
#import "ANSInfoCell.h"
#import "ANSBlacklistViewController.h"

@interface ANSOptionsViewController : UITableViewController
@property (strong, nonatomic) ANSBlacklistViewController *blacklistViewController;
@property (strong, nonatomic) NSDictionary *optionsDictionary;
@property (strong, nonatomic) NSDictionary *accountSettings;
@property (strong, nonatomic) NSDictionary *friendSettings;
@property (strong, nonatomic) NSDictionary *infoCollection;
@property (strong, nonatomic) NSArray *orderedKeys;
@property (strong, nonatomic) NSArray *friends;
-(void)initializeSettings;
@end
