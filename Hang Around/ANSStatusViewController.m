//
//  ANSStatusViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 7/2/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSStatusViewController.h"

@interface ANSStatusViewController ()

@end

@implementation ANSStatusViewController
@synthesize statusView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        CGPoint center = CGPointMake(frame.origin.x + (frame.size.width/2), frame.origin.y + (frame.size.height/2));
        statusView = [[ANSStatusView alloc] initWithMenuFrame:
                       CGRectMake(center.x - 125, center.y - 125 - 44, 250, 250)
                                              andVisibleFrame:
                       CGRectMake(frame.origin.x, frame.size.height-44, frame.size.width, 44)];
        [statusView setStatusViewDelegate:self];
        [self setView:statusView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ANSStatusViewDelegate
-(void)tappedVisibleView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.adamsuskin.hangaround.toggleBackgroundTint" object:nil];
}

-(void)statusViewDidChangeSelection:(id)statView
{
    ANSStatusView *tmpView = (ANSStatusView *)statView;
    [[PFUser currentUser] setObject:[NSNumber numberWithInt:[tmpView selectedIndex]] forKey:@"state"];
    [[PFUser currentUser] setObject:[[tmpView textArray] objectAtIndex:[tmpView selectedIndex]] forKey:@"status"];
    [[PFUser currentUser] saveInBackground];
}

@end
