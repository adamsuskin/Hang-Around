//
//  ANSAppDelegate.h
//  Hang Around
//
//  Created by Adam Suskin on 6/30/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreData/CoreData.h>
#import "ANSServerHandler.h"

@class ANSViewController;

@interface ANSAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ANSViewController *viewController;

@property (strong, nonatomic) ANSServerHandler *haServerHandler;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSString *)applicationDocumentsDirectory;

@end
