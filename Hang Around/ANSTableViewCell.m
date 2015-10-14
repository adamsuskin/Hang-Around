//
//  ANSTableViewCell.m
//  Hang Around
//
//  Created by Adam Suskin on 7/13/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSTableViewCell.h"

@implementation ANSTableViewCell
@synthesize nameLabel, statusLabel, profPicView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:[[[self textLabel] font] pointSize]]];
        [[self detailTextLabel] setFont:[UIFont fontWithName:@"Helvetica" size:[[[self detailTextLabel] font] pointSize]]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
