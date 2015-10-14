//
//  ANSServerHandler.h
//  Hang Around
//
//  Created by Adam Suskin on 7/4/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Friend.h"

@interface ANSServerHandler : NSObject
{
    BOOL shouldUpdateHAUser;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
/*
@property (strong, nonatomic) Friend *haUser;
@property (strong, nonatomic) NSSet *haFriends;
 */

-(id)initWithManagedContext:(NSManagedObjectContext *)context;
//-(NSArray *)fetchParseFacebookFriends;
+(void)fetchFacebookFriendIDsWithCallback:(void (^)(NSArray* results))callback;
+(void)fetchBlacklistDataWithCallback:(void (^)(NSArray * results))callback;
/*
-(void)downloadAllFriends;
-(void)downloadNewFriends;
-(Friend *)fetchCurrentUser;
 */
@end
