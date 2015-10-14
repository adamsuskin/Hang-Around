//
//  ANSQueryTableViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 7/20/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <Parse/Parse.h>
#import "ANSTableViewCell.h"
#import "ANSSessionHandler.h"
#import "ANSServerHandler.h"

@interface ANSQueryTableViewController : PFQueryTableViewController
{
    BOOL firstLoad;
}
@property (strong, nonatomic) NSArray *friendIds;
@property (strong, nonatomic) NSMutableDictionary *pushTimes;
@end
