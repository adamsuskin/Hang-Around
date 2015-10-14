//
//  ANSStatusViewItem.h
//  Hang Around
//
//  Created by Adam Suskin on 7/21/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ANSStatusViewItemDelegate <NSObject>

-(void)handleTap:(id)item;

@end

@interface ANSStatusViewItem : UIView
@property (strong, nonatomic) id<ANSStatusViewItemDelegate> statusViewItemDelegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *icon;
-(id)initWithTitle:(NSString *)title andColor:(UIColor *)color;
@end
