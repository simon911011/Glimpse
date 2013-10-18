//
//  Day.h
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Days *parent;

@end
