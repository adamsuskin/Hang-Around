//
//  ANSStatusView.m
//  Hang Around
//
//  Created by Adam Suskin on 7/2/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSStatusView.h"

@implementation ANSStatusView
@synthesize selectedIndex, textArray, colorsArray, visibleView, menuView, statusViewDelegate, itemsArray;
@synthesize visibleViewLabel;

-(id)initWithMenuFrame:(CGRect)menuFrame andVisibleFrame:(CGRect)visibleFrame;
{
    CGFloat xMin = (menuFrame.origin.x < visibleFrame.origin.x ? menuFrame.origin.x : visibleFrame.origin.x);
    CGFloat yMin = (menuFrame.origin.y < visibleFrame.origin.y ? menuFrame.origin.y : visibleFrame.origin.y);
    CGFloat xMax = (menuFrame.origin.x+menuFrame.size.width > visibleFrame.origin.x+visibleFrame.size.width
                    ? menuFrame.origin.x+menuFrame.size.width : visibleFrame.origin.x+visibleFrame.size.width);
    CGFloat yMax = (menuFrame.origin.y+menuFrame.size.height > visibleFrame.origin.y+visibleFrame.size.height
                    ? menuFrame.origin.y+menuFrame.size.height : visibleFrame.origin.y+visibleFrame.size.height);
    
    self = [super initWithFrame:CGRectMake(xMin, yMin, xMax-xMin, yMax-yMin)];
    
    if (self) {
        tapped = NO;
        selectedIndex = 1;
        textArray = [ANSSessionHandler textArray];
        colorsArray = [ANSSessionHandler colorsArray];
        itemsArray = [ANSSessionHandler statusItemsArray];
        for (ANSStatusViewItem *item in itemsArray)
            [item setStatusViewItemDelegate:self];
        [self createMenuView:menuFrame];
        [self createVisibleView:visibleFrame];
        
    }
    return self;
}

-(void)createMenuView:(CGRect)menuFrame
{
    menuView = [[UIView alloc] initWithFrame:CGRectMake(menuFrame.origin.x - self.frame.origin.x, menuFrame.origin.y - self.frame.origin.y, menuFrame.size.width, menuFrame.size.height)];
    [menuView setBackgroundColor:[UIColor blackColor]];
    [[menuView layer] setCornerRadius:20.0];
    
    [self createMenuViewItems];
    
    [menuView setHidden:YES];
        
    [self addSubview:menuView];
}

-(void)createMenuViewItems
{
    for (ANSStatusViewItem *item in itemsArray){
        int indexOfObject = [itemsArray indexOfObject:item];
        CGFloat xCoord, yCoord;
        if(indexOfObject % 2 == 0){
            xCoord = 23;
        }
        else {
            xCoord = 46 + [item bounds].size.width;
            indexOfObject -= 1;
        }
        if((indexOfObject/2) % 2 == 0){
            yCoord = 23;
        }
        else {
            yCoord = 46 + [item bounds].size.height;
        }
        [item setFrame:CGRectMake(xCoord, yCoord, [item bounds].size.width, [item bounds].size.height)];
        [menuView addSubview:item];
    }
}

-(void)createVisibleView:(CGRect)visibleFrame
{
    visibleView = [[UIView alloc] initWithFrame:CGRectMake(visibleFrame.origin.x - self.frame.origin.x, visibleFrame.origin.y - self.frame.origin.y, visibleFrame.size.width, visibleFrame.size.height)];
    [visibleView setBackgroundColor:[colorsArray objectAtIndex:selectedIndex]];
    [[visibleView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[visibleView layer] setShadowOpacity:0.4];
    [[visibleView layer] setShadowRadius:2.5];
    [[visibleView layer] setShadowOffset:CGSizeMake(0.0, -2.0)];
    
    visibleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, visibleView.frame.size.width, visibleView.frame.size.height)];
    [visibleViewLabel setBackgroundColor:[UIColor clearColor]];
    [visibleViewLabel setTextAlignment:NSTextAlignmentCenter];
    [visibleViewLabel setTextColor:[UIColor blackColor]];
    
    [self refreshVisibleViewLabel];
    
    [visibleView addSubview:visibleViewLabel];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(visibleViewTapped:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [visibleView addGestureRecognizer:tapGestureRecognizer];
    
    [self addSubview:visibleView];
}

-(void)refreshVisibleViewLabel
{
    NSString *tmpString = @"I Am ";
    NSString *updateString = [textArray objectAtIndex:selectedIndex];
    // Create the attributes
    const CGFloat fontSize = 20;
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    UIFont *regularFont = [UIFont fontWithName:@"Helvetica" size:fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName,
                              nil];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:tmpString
                                           attributes:attrs];
    NSAttributedString *tmpAttributedText =
    [[NSAttributedString alloc] initWithString:updateString attributes:subAttrs];
    
    [attributedText appendAttributedString:tmpAttributedText];
    // Set it in our UILabel and we are done!
    [visibleViewLabel setAttributedText:attributedText];
}

-(void)visibleViewTapped:(BOOL)notDone
{
    if (tapped == NO) {
        [statusViewDelegate tappedVisibleView];
        [self toggleMenuView];
    }
    if (notDone)
        tapped = YES;
}

-(void)handleTap:(id)item
{
    tapped = NO;
    ANSStatusViewItem *statusViewItem = (ANSStatusViewItem *)item;
    [self visibleViewTapped:NO];
    int newIndex = [itemsArray indexOfObject:statusViewItem];
    if([self selectedIndex] != newIndex){
        [self setSelectedIndex:newIndex];
        [self updateView];
    }
}

-(void)updateView
{
    [visibleView setBackgroundColor:[colorsArray objectAtIndex:selectedIndex]];
    [self refreshVisibleViewLabel];
    [statusViewDelegate statusViewDidChangeSelection:self];
}

-(void)toggleMenuView
{
    if([menuView isHidden]){
        [menuView setHidden:NO];
        [[menuView layer] addAnimation:[self popUpAnimation] forKey:nil];
    }
    else{
        [menuView setHidden:YES];
    }
}

-(CAAnimation *)popUpAnimation
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    
    return animation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}
*/

@end
