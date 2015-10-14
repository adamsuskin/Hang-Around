//
//  ANSStatusView.h
//  Hang Around
//
//  Created by Adam Suskin on 7/2/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ANSSessionHandler.h"

@protocol ANSStatusViewDelegate <NSObject>
-(void)tappedVisibleView;
-(void)statusViewDidChangeSelection:(id)statView;
@end

@interface ANSStatusView : UIView <ANSStatusViewItemDelegate>
{
    BOOL tapped;
}
@property (nonatomic) NSUInteger selectedIndex;
@property (strong, nonatomic) UIView *visibleView;
@property (strong, nonatomic) UILabel *visibleViewLabel;
@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) NSArray *textArray;
@property (strong, nonatomic) NSArray *colorsArray;
@property (strong, nonatomic) NSArray *itemsArray;
@property (weak, nonatomic) id<ANSStatusViewDelegate> statusViewDelegate;
-(void)updateView;
-(id)initWithMenuFrame:(CGRect)menuFrame andVisibleFrame:(CGRect)visibleFrame;
@end
