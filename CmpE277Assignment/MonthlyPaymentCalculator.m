//
//  MonthlyPaymentCalculator.m
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/27/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import "MonthlyPaymentCalculator.h"

@implementation MonthlyPaymentCalculator

+ (void)monthlyPaymentForPrinciple:(NSNumber *)principle atRate:(NSNumber *)loanRate forPeriod:(NSNumber *)period resultBlock:(CalculationResponseBlock)responseBlock
{
	NSNumber *interestRate = [NSNumber numberWithFloat:loanRate.floatValue/100];
	interestRate = [NSNumber numberWithFloat:interestRate.floatValue/12];
	
	NSNumber *months = [NSNumber numberWithInteger:period.integerValue*12];
	
	NSNumber *temp = [NSNumber numberWithFloat:powf(1+interestRate.floatValue, months.floatValue)];
	
	NSNumber *paymentAmount;
	if (temp.floatValue - 1.0 == 0.0)
		paymentAmount = [NSNumber numberWithFloat:(principle.floatValue/months.floatValue)];
	else
		paymentAmount = [NSNumber numberWithFloat:(principle.floatValue*((interestRate.floatValue * temp.floatValue)/(temp.floatValue-1)))];
	
	NSDictionary *responseDict;
	if (isnan(paymentAmount.floatValue) || isinf(paymentAmount.floatValue))
		responseDict = [NSDictionary dictionaryWithObject:@"N/A" forKey:@"result"];
	else
		responseDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%.2f", paymentAmount.floatValue] forKey:@"result"];
	
	responseBlock(responseDict);
}


@end