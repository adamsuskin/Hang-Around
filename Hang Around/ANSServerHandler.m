//
//  ANSServerHandler.m
//  Hang Around
//
//  Created by Adam Suskin on 7/4/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSServerHandler.h"

@implementation ANSServerHandler
@synthesize fetchedResultsController, managedObjectContext;
//@synthesize haUser, haFriends;

-(id)initWithManagedContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        managedObjectContext = context;
        shouldUpdateHAUser = YES;
    }
    return self;
}
/*
-(NSArray *)fetchParseFacebookFriends
{
    NSMutableArray *friendUsers = [[NSMutableArray alloc] init];
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbID" containedIn:friendIds];
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(error)
                    NSLog(@"%@", [error localizedDescription]);
                for (PFUser *user in objects){
                    [friendUsers addObject:user];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"com.adamsuskin.hangaround.dataUpdated" object:self];
            }];
        }
        else
            NSLog(@"%@", [error localizedDescription]);
    }];
    return friendUsers;
}
 */

+(void)fetchFacebookFriendIDsWithCallback:(void (^)(NSArray* results))callback
{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            callback(friendIds);
        }
    }];
}

+(void)fetchBlacklistDataWithCallback:(void (^)(NSArray * results))callback
{
    PFQuery *subqueryOne = [PFQuery queryWithClassName:@"Blacklist"];
    [subqueryOne whereKey:@"blacklistee" equalTo:[PFUser currentUser]];
    PFQuery *subqueryTwo = [PFQuery queryWithClassName:@"Blacklist"];
    [subqueryTwo whereKey:@"blacklister" equalTo:[PFUser currentUser]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:subqueryOne, subqueryTwo, nil]];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
            NSLog(@"%@", [error localizedDescription]);
        else {
            callback(objects);
        }
    }];
}

/*
-(void)downloadAllFriends
{
    NSLog(@"All friends downloaded!");
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            Friend *me = [self fetchCurrentUser];
            NSArray *friendUsers = [friendQuery findObjects];
            NSMutableSet *children = [[NSMutableSet alloc] initWithCapacity:[friendUsers count]];
            for (PFUser *tmpUser in friendUsers){
                Friend *tmpFriend = [[Friend alloc] initWithEntity:[NSEntityDescription entityForName:@"Friend" inManagedObjectContext:managedObjectContext]
                                    insertIntoManagedObjectContext:managedObjectContext];
                [tmpFriend setFbID:[tmpUser objectForKey:@"fbID"]];
                [tmpFriend setParseID:[tmpUser objectForKey:@"objectId"]];
                [tmpFriend setOwner:me];
                [children addObject:tmpFriend];
            }
            [me setChildren:children];
            for (Friend *tmp in children)
                [managedObjectContext save:nil];
            NSError *error;
            [managedObjectContext save:&error];
            if(error)
                NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(NSSet *)haFriends
{
    return [haUser children];
}

-(Friend *)fetchCurrentUser
{
    if(shouldUpdateHAUser){
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Friend" inManagedObjectContext:managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fbID like %@", [[PFUser currentUser] objectForKey:@"fbID"]];
        [request setPredicate:predicate];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        Friend *result;
        if ([results count] > 0)
            result = [results objectAtIndex:0];
        else {
            Friend *me = [[Friend alloc] init];
            [me setParseID:[[PFUser currentUser] objectId]];
            [me setFbID:[[PFUser currentUser] objectForKey:@"fbID"]];
            result = me;
        }
        if(error)
            NSLog(@"%@", [error localizedDescription]);
        if(result)
            haUser = result;
        shouldUpdateHAUser = NO;
    }
    return haUser;
}

-(void)downloadNewFriends
{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            Friend *me = [self fetchCurrentUser];
            NSMutableArray *existingFriendIds = [NSMutableArray arrayWithCapacity:[[me children] count]];
            for (Friend *tmp in [me children])
                [existingFriendIds addObject:[tmp fbID]];
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbID" containedIn:friendIds];
            [friendQuery whereKey:@"fbID" notContainedIn:existingFriendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            NSMutableSet *children = [[NSMutableSet alloc] initWithCapacity:[friendUsers count]];
            for (PFUser *tmpUser in friendUsers){
                Friend *tmpFriend = [[Friend alloc] initWithEntity:[NSEntityDescription entityForName:@"Friend" inManagedObjectContext:managedObjectContext]
                                    insertIntoManagedObjectContext:managedObjectContext];
                [tmpFriend setFbID:[tmpUser objectForKey:@"fbID"]];
                [tmpFriend setParseID:[tmpUser objectForKey:@"objectId"]];
                [tmpFriend setOwner:me];
                [children addObject:tmpFriend];
            }
            for (Friend *tmp in children)
                [managedObjectContext save:nil];
            for (Friend *tmp in [me children]){
                [children addObject:tmp];
            }
            [me setChildren:children];
            NSError *error;
            [managedObjectContext save:&error];
            if(error)
                NSLog(@"%@", [error localizedDescription]);
        }
    }];

}
 */

@end
