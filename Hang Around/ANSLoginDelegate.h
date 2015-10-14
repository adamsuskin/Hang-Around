//
//  ANSLoginDelegate.h
//  Hang Around
//
//  Created by Adam Suskin on 7/1/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANSLoginDelegate <NSObject>

-(void)handleLogIn:(id)sender;
-(void)handleLogOut:(id)sender;

@end
