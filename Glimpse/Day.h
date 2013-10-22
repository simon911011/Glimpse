//
//  Day.h
//  Glimpse
//
//  Created by Shao Ping Lee on 10/21/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSManagedObject *parent;

@end
