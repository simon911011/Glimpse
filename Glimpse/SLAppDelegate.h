//
//  SLAppDelegate.h
//  Glimpses
//
//  Created by Shao Ping Lee on 8/17/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
