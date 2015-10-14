//
//  Friend.h
//  Hang Around
//
//  Created by Adam Suskin on 7/12/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * parseID;
@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) Friend *owner;
@property (nonatomic, retain) NSSet *children;

@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Friend *)value;
- (void)removeChildrenObject:(Friend *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
