//
//  ANSSessionHandler.h
//  Hang Around
//
//  Created by Adam Suskin on 7/15/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ANSStatusViewItem.h"

typedef struct {
    int days;
    int hours;
    int minutes;
    int seconds;
} ANSTimeInterval;

enum kANSState {
    kANSLooking = 0,
    kANSAvailable = 1,
    kANSBusy = 2,
    kANSAway = 3
    };

@interface ANSSessionHandler : NSObject
+(CGSize)windowSize;
+(ANSTimeInterval)formattedTimeInterval:(NSTimeInterval)timeInterval;
+(NSString *)highestTimeInterval:(ANSTimeInterval)timeInterval;
+(UIImage*)imageWithBorderFromImage:(UIImage*)source;
+(NSArray*)colorsArray;
+(NSArray*)textArray;
+(NSArray*)statusItemsArray;
+(NSDictionary*)userDictionary;
+(NSDictionary*)infoCollection;
@end
