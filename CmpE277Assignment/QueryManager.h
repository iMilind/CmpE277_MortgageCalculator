//
//  QueryManager.h
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/26/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"


typedef void (^SaveBlockResponse) (BOOL isSuccess);
typedef void (^DeleteBlockResponse) (BOOL isSuccess);


@interface QueryManager : NSObject

+ (void)saveLocation:(NSDictionary *)location completionBlock:(SaveBlockResponse)onCompletion;
+ (void)deleteLocation:(Location *)location onCompletion:(DeleteBlockResponse)onCompletion;
+ (NSArray *)fetchAllLocations;


@end