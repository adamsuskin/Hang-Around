//
//  ANSSessionHandler.m
//  Hang Around
//
//  Created by Adam Suskin on 7/15/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSSessionHandler.h"

@implementation ANSSessionHandler

+(CGSize)windowSize
{
    return [[UIScreen mainScreen] bounds].size;
}

+(ANSTimeInterval)formattedTimeInterval:(NSTimeInterval)timeInterval
{
    ANSTimeInterval interval;
    int intervalInSecs = (int)timeInterval;
    
    int days = intervalInSecs / 86400;
    interval.days = days;
    intervalInSecs -= (days * 86400);
    
    int hours = intervalInSecs / 3600;
    interval.hours = hours;
    intervalInSecs -= (hours * 3600);
    
    int minutes = intervalInSecs / 60;
    interval.minutes = minutes;
    intervalInSecs -= (minutes * 60);
    
    interval.seconds = intervalInSecs;
    return interval;
}

+(NSString *)highestTimeInterval:(ANSTimeInterval)timeInterval
{
    NSMutableString *returner;
    if (timeInterval.days > 0){
        returner = [NSMutableString stringWithFormat:@"%d day", timeInterval.days];
        if(timeInterval.days > 1)
           [returner appendString:@"s"];
        return returner;
    }
    if (timeInterval.hours > 0){
        returner = [NSMutableString stringWithFormat:@"%d hour", timeInterval.hours];
        if(timeInterval.hours > 1)
            [returner appendString:@"s"];
        return returner;
    }
    if (timeInterval.minutes > 0){
        returner = [NSMutableString stringWithFormat:@"%d minute", timeInterval.minutes];
        if(timeInterval.minutes > 1)
            [returner appendString:@"s"];
        return returner;
    }
    returner = [NSMutableString stringWithFormat:@"%d second", timeInterval.seconds];
    if(timeInterval.seconds != 1)
        [returner appendString:@"s"];
    return returner;
}

+ (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

+(NSArray*)colorsArray
{
    return [NSArray arrayWithObjects:
            [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0],
            [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
            [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0],
            [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0],
            nil];
}

+(NSArray*)textArray
{
    return [NSArray arrayWithObjects:
     @"Looking",
     @"Available",
     @"Busy",
     @"Away",
     nil];
}

+(NSArray*)statusItemsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[[self colorsArray] count]];
    for (int i = 0; i < [[self colorsArray] count]; i++) {
        [array addObject:[[ANSStatusViewItem alloc] initWithTitle:[[self textArray] objectAtIndex:i] andColor:[[self colorsArray] objectAtIndex:i]]];
    }
    return array;
}

+(NSDictionary *)createAccountSettings
{
    NSMutableDictionary *accountSettings = [[NSMutableDictionary alloc] init];
    
    [accountSettings setObject:[[PFUser currentUser] objectForKey:@"name"] forKey:@"name"];
    [accountSettings setObject:[[PFUser currentUser] objectForKey:@"email"] forKey:@"email"];
    
    return accountSettings;
}

+(NSDictionary *)createFriendSettings
{
    NSMutableDictionary *friendSettings = [[NSMutableDictionary alloc] init];
    
    [friendSettings setObject:[NSArray array] forKey:@"blacklist"];
    [friendSettings setObject:[NSDictionary dictionary] forKey:@"notifications"];
    
    return friendSettings;
}

+(NSDictionary *)userDictionary
{
    NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:[[PFUser currentUser] objectForKey:@"fbID"]];
    if (userDictionary == nil){
        userDictionary = [[NSDictionary alloc]
                          initWithObjects:[NSArray arrayWithObjects:[ANSSessionHandler createAccountSettings], [ANSSessionHandler createFriendSettings], nil]
                          forKeys:[NSArray arrayWithObjects:@"accountSettings", @"friendSettings", nil]];
        [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:[[PFUser currentUser] objectForKey:@"fbID"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return userDictionary;
}

+(NSDictionary *)infoCollection
{
    NSDictionary *infoCollection = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"infoCollection"];
    if(infoCollection == nil) {
        infoCollection = [[NSDictionary alloc] init];
    }
    return infoCollection;
}

@end
