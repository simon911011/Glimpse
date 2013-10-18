//
//  Day+Management.m
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "Day+Management.h"

static NSString *entityName = @"Day";

@implementation Day (Management)


+ (Day *)insertDayWithDate: (NSDate *)date URL: (NSString *)url MediaType: (NSString *)type Parent: (Days *)parent ManagedObjectContext: (NSManagedObjectContext *)moc
{
    
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                             inManagedObjectContext:moc];
    day.date = date;
    day.url = url;
    day.type = type;
    day.parent = parent;
    
    return day;
}
+ (Day *)insertDayWithDate:(NSDate *)date URL:(NSString *)url MediaType:(NSString *)type Parent: (Days *)parent
{
    return [Day insertDayWithDate:date
                              URL:url
                        MediaType:type
                           Parent:parent
             ManagedObjectContext:defaultManagedObjectContext()];
}


@end
