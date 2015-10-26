//
//  QueryManager.m
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/26/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import "QueryManager.h"
#import "DBManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation QueryManager


+(NSEntityDescription *)getEntityDescriptionForClass:(NSString *)entity
{
	return [NSEntityDescription entityForName:entity inManagedObjectContext:[[DBManager sharedManager] managedObjectContext]];
}

+ (void)saveLocation:(NSDictionary *)location completionBlock:(SaveBlockResponse)onCompletion
{
	Location *newLocation = [[Location alloc] initWithEntity:[QueryManager getEntityDescriptionForClass:NSStringFromClass([Location class])] insertIntoManagedObjectContext:[[DBManager sharedManager] managedObjectContext]];
	
	CLPlacemark *placemark = [location objectForKey:@"location"];
	newLocation.propertyType = [location objectForKey:@"propertyType"];
	newLocation.address = placemark.name;
	newLocation.city = placemark.locality;
	newLocation.state = placemark.administrativeArea;
	newLocation.zip = placemark.postalCode;
	newLocation.loanAmount = [NSNumber numberWithFloat:[[location objectForKey:@"loanAmount"] floatValue]];
	newLocation.downPay = [NSNumber numberWithFloat:[[location objectForKey:@"downPayment"] floatValue]];
	newLocation.apr = [NSNumber numberWithFloat:[[location objectForKey:@"APR"] floatValue]];
	newLocation.repayPeriod = [NSNumber numberWithInteger:[[location objectForKey:@"repayPeriod"] integerValue]];
	newLocation.monthlyPay = [NSNumber numberWithFloat:[[location objectForKey:@"monthly"] floatValue]];;
	
	newLocation.latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
	newLocation.longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
	
	if ([[[DBManager sharedManager] managedObjectContext] save:nil])
		onCompletion(YES);
	else
		onCompletion(NO);
}

+ (void)deleteLocation:(Location *)location onCompletion:(DeleteBlockResponse)onCompletion
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [QueryManager getEntityDescriptionForClass:NSStringFromClass([Location class])];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"address == %@", location.address];
    
    NSArray *fetchedObjects = [[[DBManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    [[[DBManager sharedManager] managedObjectContext] deleteObject:[fetchedObjects lastObject]];

    if ([[[DBManager sharedManager] managedObjectContext] save:nil])
        onCompletion(YES);
    else
        onCompletion(NO);
}

+ (NSArray *)fetchAllLocations
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [QueryManager getEntityDescriptionForClass:NSStringFromClass([Location class])];
	[fetchRequest setEntity:entity];
	
	NSArray *fetchedObjects = [[[DBManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];

	return fetchedObjects;
}

@end