//
//  ANSBlacklistCell.m
//  Hang Around
//
//  Created by Adam Suskin on 7/29/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSBlacklistCell.h"

@implementation ANSBlacklistCell
@synthesize titleLabel, blockButton, correspondingUser;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(IBAction)block:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.adamsuskin.hangaround.blockSelected" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:correspondingUser, [NSNumber numberWithBool:[blockButton isHighlighted]], nil] forKeys:[NSArray arrayWithObjects:@"user", @"isSelected", nil]]];
    if([blockButton isHighlighted]){
        [blockButton setHighlighted:NO];
        [self setImageToBlock:blockButton];
    }
    else {
        [blockButton setHighlighted:YES];
        [self setImageToUnblock:blockButton];
    }
}

-(void)setImageToBlock:(UIButton *)view
{
    [view setBackgroundImage:[UIImage imageNamed:@"hangAroundButton.png"] forState:UIControlStateNormal];
}

-(void)setImageToUnblock:(UIButton *)view
{
    [view setBackgroundImage:[UIImage imageNamed:@"hangAroundBlockButton.png"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
