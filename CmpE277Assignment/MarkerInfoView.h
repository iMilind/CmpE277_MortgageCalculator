//
//  MarkerInfoView.h
//  CmpE277Assignment
//
//  Created by akshay talathi on 4/27/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MarkerInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *propertyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak) id location;


@end
