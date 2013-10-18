//
//  Days+Management.m
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "Days+Management.h"

static NSString *entityName = @"Days";

@implementation Days (Management)

+ (Days *)insertDaysWithRound: (NSNumber *)round managedObjectContext: (NSManagedObjectContext *)moc
{
    Days *days = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
    days.round = round;
    
    return days;
}
+ (Days *)insertDaysWithRound: (NSNumber *)round
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Days insertDaysWithRound:round managedObjectContext:moc];
}
+ (Days *)daysWithRound: (NSNumber *)round
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"round == %@", round];
    
    NSArray *sort = @[[NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]];
    Days *days = (Days *)fetchManagedObject(entityName,
                                            predicate,
                                            sort,
                                            defaultManagedObjectContext());
    
    return days;
}

@end
