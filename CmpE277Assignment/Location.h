//
//  Location.h
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/26/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * propertyType;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * loanAmount;
@property (nonatomic, retain) NSNumber * downPay;
@property (nonatomic, retain) NSNumber * apr;
@property (nonatomic, retain) NSNumber * repayPeriod;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * monthlyPay;

@end
