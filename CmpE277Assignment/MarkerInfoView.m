//
//  MarkerInfoView.m
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/27/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import "MarkerInfoView.h"

@implementation MarkerInfoView

@synthesize location;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)init
{
	self = [super init];
	if (self)
	{
		self = [[[NSBundle mainBundle] loadNibNamed:@"MarkerInfoView" owner:self options:nil] objectAtIndex:0];

		[self sendSubviewToBack:_imageView];
	}
	
	return self;
}


@end