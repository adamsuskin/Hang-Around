//
//  ANSBlacklistCell.h
//  Hang Around
//
//  Created by Adam Suskin on 7/29/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANSButton.h"

@interface ANSBlacklistCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *blockButton;
@property (strong, nonatomic) PFUser *correspondingUser;
-(IBAction)block:(id)sender;
@end
