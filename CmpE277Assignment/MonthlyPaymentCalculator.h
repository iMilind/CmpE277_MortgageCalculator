//
//  MonthlyPaymentCalculator.h
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/27/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^CalculationResponseBlock) (NSDictionary *responseDict);


@interface MonthlyPaymentCalculator : NSObject


+ (void)monthlyPaymentForPrinciple:(NSNumber *)principle atRate:(NSNumber *)loanRate forPeriod:(NSNumber *)period resultBlock:(CalculationResponseBlock)responseBlock;

@end