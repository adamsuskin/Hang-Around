//
//  ANSTableViewCell.h
//  Hang Around
//
//  Created by Adam Suskin on 7/13/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANSTableViewCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profPicView;
@end
