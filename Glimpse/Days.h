//
//  Days.h
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Days : NSManagedObject

@property (nonatomic, retain) NSNumber *round;
@property (nonatomic, retain) NSSet *children;
@end

@interface Days (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Day *)value;
- (void)removeChildrenObject:(Day *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
