//
//  ANSStatusViewItem.m
//  Hang Around
//
//  Created by Adam Suskin on 7/21/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSStatusViewItem.h"

@implementation ANSStatusViewItem
@synthesize titleLabel, icon, statusViewItemDelegate;

-(id)initWithTitle:(NSString *)title andColor:(UIColor *)color
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ANSStatusViewItem" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        [titleLabel setText:title];
        [icon setBackgroundColor:color];
        [[icon layer] setCornerRadius:5.0];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(tapRecognized)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [tapGestureRecognizer setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

-(void)tapRecognized
{
    [statusViewItemDelegate handleTap:self];
}

-(BOOL)isEqual:(id)object
{
    ANSStatusViewItem *item = (ANSStatusViewItem *)object;
    if([[[self icon] backgroundColor] isEqual:[[object icon] backgroundColor]] && [[[self titleLabel] text] isEqual:[[item titleLabel] text]])
        return YES;
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
