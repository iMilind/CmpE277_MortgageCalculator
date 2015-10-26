//
//  DBManager.m
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/26/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedManager = nil;

@implementation DBManager

+ (DBManager *)sharedManager
{
	@synchronized(self)
	{
		if (sharedManager == nil)
			sharedManager = [[self alloc] init];
	}
	return sharedManager;
}


- (id)init
{
	if (self = [super init])
	{
		[self managedObjectContext];
	}
	
	return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (managedObjectContext != nil)
		return managedObjectContext;

	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

	if (coordinator != nil)
	{
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel != nil)
		return managedObjectModel;
	
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (persistentStoreCoordinator != nil)
		return persistentStoreCoordinator;
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"LocationDetails.sqlite"]];
	NSError *error = nil;
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

	if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
	{
		
	}
	
	return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end