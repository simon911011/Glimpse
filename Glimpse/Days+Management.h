//
//  Days+Management.h
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "Days.h"
#import "ModelUtil.h"

@interface Days (Management)

+ (Days *)insertDaysWithRound: (NSNumber *)round managedObjectContext: moc;
+ (Days *)insertDaysWithRound: (NSNumber *)round;
+ (Days *)daysWithRound: (NSNumber *)round;

@end
