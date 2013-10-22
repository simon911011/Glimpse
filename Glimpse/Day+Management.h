//
//  Day+Management.h
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "Day.h"
#import "Days.h"
#import "ModelUtil.h"

@interface Day (Management)

+ (Day *)insertDayWithDate:(NSDate *)date URL:(NSString *)url comment:(NSString *)comment MediaType:(NSString *)type Parent:(Days *)parent ManagedObjectContext: (NSManagedObjectContext *)moc;
+ (Day *)insertDayWithDate:(NSDate *)date URL:(NSString *)url comment:(NSString *)comment MediaType:(NSString *)type Parent:(Days *)parent;

@end
