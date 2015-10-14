//
//  ANSButton.m
//  Hang Around
//
//  Created by Adam Suskin on 7/22/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSButton.h"

@implementation ANSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"hangAroundButton.png"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"Title" forState:UIControlStateNormal];
        [[self titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        
        [self addTarget:self action:@selector(disableShadow) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(enableShadow) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(enableShadow) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(enableShadow) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(enableShadow) forControlEvents:UIControlEventTouchCancel];
        
        [[self layer] setShadowColor:[UIColor blackColor].CGColor];
        [[self layer] setShadowOpacity:0.4];
        [[self layer] setShadowRadius:2.5];
        [[self layer] setShadowOffset:CGSizeMake(0, 2)];
    }
    return self;
}

-(void)disableShadow
{
    [[self layer] setShadowOpacity:0.0];
}

-(void)enableShadow
{
    [[self layer] setShadowOpacity:0.4];
}

-(void)setHighlighted:(BOOL)highlighted
{
    
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
