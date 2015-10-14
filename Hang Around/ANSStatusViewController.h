//
//  ANSStatusViewController.h
//  Hang Around
//
//  Created by Adam Suskin on 7/2/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSStatusView.h"
#import <Parse/Parse.h>

@interface ANSStatusViewController : UIViewController <ANSStatusViewDelegate>
@property (strong, nonatomic) ANSStatusView* statusView;
-(id)initWithFrame:(CGRect)frame;
@end
