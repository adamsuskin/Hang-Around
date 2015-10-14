//
//  ANSBlacklistViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 7/28/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANSBlacklistCell.h"
#import "ANSServerHandler.h"

@interface ANSBlacklistViewController : UITableViewController
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *friends;
@end
