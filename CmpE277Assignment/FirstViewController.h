//
//  FirstViewController.h
//  CmpE277Assignment
//
//  Created by Sushanta Sahoo on 4/21/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *downPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualPercentRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPaymentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *propertyTypeButton;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectStateButton;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *loanAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *downPaymentTextField;
@property (weak, nonatomic) IBOutlet UITextField *annualPercentRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *termsTextField;


- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)newButtonClicked:(id)sender;
- (IBAction)propertyTypeButtonClicked:(id)sender;
- (IBAction)selectStateButtonClicked:(id)sender;
- (void)fillLocationDetails:(Location *)location;


@end