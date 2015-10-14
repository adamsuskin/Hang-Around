//
//  ANSInfoCell.m
//  Hang Around
//
//  Created by Adam Suskin on 7/24/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSInfoCell.h"

@implementation ANSInfoCell
@synthesize titleLabel, contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
