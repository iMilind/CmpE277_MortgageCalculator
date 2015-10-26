//
//  FirstViewController.m
//  CmpE277Assignment
//
//  Created by Sushanta Sahoo on 4/21/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#define KEYBOARD_STANDARD_HEIGHT 256

#import <CoreLocation/CoreLocation.h>

#import "FirstViewController.h"
#import "QueryManager.h"
#import "Location.h"
#import "MonthlyPaymentCalculator.h"


typedef void (^GeocoderResponseBlock)(NSArray *responseArray);


@interface FirstViewController () <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL isEditing;
	BOOL isFrameModified;
	CLGeocoder *geocoder;
    UIPickerView *statePickerView;
    NSArray *stateArray;
}

@property (strong) Location *editingLocation;

@end


@implementation FirstViewController


#pragma mark
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    isEditing = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[_imageView setAlpha:0.75];
	CALayer *maskLayer = [CALayer layer];
	
	maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f  alpha:0.75f] CGColor];
	maskLayer.contents = (id)[[UIImage imageNamed:@"Mask.png"] CGImage];
	
	
	maskLayer.contentsGravity = kCAGravityCenter;
	maskLayer.frame = CGRectMake(_viewTitleLabel.frame.size.width * -1, 0.0f,   _viewTitleLabel.frame.size.width * 2, _viewTitleLabel.frame.size.height);
	
	CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
	maskAnim.byValue = [NSNumber numberWithFloat:_viewTitleLabel.frame.size.width];
	maskAnim.repeatCount = HUGE_VALF;
	maskAnim.duration = 1.0f;
	[maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
	_viewTitleLabel.layer.mask = maskLayer;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setBorderWidth:1.0f andColor:[UIColor blackColor] forView:_selectStateButton];
	[self setBorderWidth:1.0f andColor:[UIColor blackColor] forView:_propertyTypeButton];
	[self setBorderWidth:1.0f andColor:[UIColor blackColor] forView:_addressTextView];
}

- (void)didReceiveMemoryWarning
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super didReceiveMemoryWarning];
}


#pragma mark
#pragma mark - View customization

- (void)setBorderWidth:(CGFloat)borderWidth andColor:(UIColor *)color forView:(id)view
{
	[[view layer] setBorderWidth:borderWidth];
	[[view layer] setBorderColor:[color CGColor]];
}

- (void)adjustViewFrame:(BOOL)shouldMoveUp
{
	__block CGRect selfRect = self.view.frame;
	__weak __block UIView *selfView = self.view;
	[UIView animateWithDuration:0.5 animations:^{
		if (shouldMoveUp)
			selfRect.origin.y -= 200;
		else
			selfRect.origin.y += 200;
		
		[selfView setFrame:selfRect];
	} completion:^(BOOL finished) {
		[UIView commitAnimations];
	}];
}


#pragma mark
#pragma mark - UIActions

- (IBAction)saveButtonClicked:(id)sender;
{
    if (isEditing)
        [QueryManager deleteLocation:self.editingLocation onCompletion:^(BOOL isSuccess) {
            [self performSaveOperation];
        }];
    else
        [self performSaveOperation];
}

- (IBAction)selectStateButtonClicked:(id)sender
{
    stateArray = [[NSArray alloc] initWithObjects:@"CA", @"NY", @"WA", nil];
    if (statePickerView)
        statePickerView = nil;
    statePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 250)];
    [statePickerView setShowsSelectionIndicator:YES];
    [statePickerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:statePickerView];
    [statePickerView setDataSource:self];
    [statePickerView setDelegate:self];

    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        statePickerView.frame = CGRectMake(0 , self.view.frame.size.height-250, self.view.frame.size.width, 250);
    } completion:^(BOOL finished) {
        [UIView commitAnimations];
    }];
}

- (IBAction)newButtonClicked:(id)sender
{
    isEditing = NO;
	[self setBorderWidth:1.0f andColor:[UIColor blackColor] forView:_propertyTypeButton];
	[_propertyTypeButton setTitle:@"Select" forState:UIControlStateNormal];
	
	[_addressTextView setText:@""];
	[_cityTextField setText:@""];
	[_selectStateButton setTitle:@"Select state" forState:UIControlStateNormal];
	[_zipTextField setText:@""];
	[_loanAmountTextField setText:@""];
	[_downPaymentTextField setText:@""];
	[_annualPercentRateTextField setText:@""];
	[_termsTextField setText:@""];
	[_resultLabel setText:@""];
}

- (IBAction)propertyTypeButtonClicked:(id)sender
{
	[self.view endEditing:YES];
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Propert Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:@"House", @"Apartment", nil];
	[sheet showInView:self.view];
}


#pragma mark
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 3)
	{
		return;
	}
	if (buttonIndex == 0)
	{
		[_propertyTypeButton setTitle:@"Select" forState:UIControlStateNormal];
		return;
	}
	if (buttonIndex != 0)
	{
		[_propertyTypeButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
	}
}


#pragma mark
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField.tag >= 11)
	{
		isFrameModified = YES;
		[self adjustViewFrame:YES];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (isFrameModified)
	{
		isFrameModified = NO;
		[self adjustViewFrame:NO];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[textField setText:@""];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isFirstResponder])
		[textField resignFirstResponder];
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField == _zipTextField)
	{
		if(range.length + range.location > textField.text.length)
			return NO;
		
		NSUInteger newLength = [textField.text length] + [string length] - range.length;
		return (newLength > 5) ? NO : YES;
	}

	if (textField == _downPaymentTextField)
	{
		NSString *downPayAmount = [NSString stringWithFormat:@"%@%@", _downPaymentTextField.text, string];
		if (downPayAmount.floatValue > _loanAmountTextField.text.floatValue)
		{
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Not allowed!" message:@"Down payment amount cannot be greater than the loan amount." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[errorAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
			errorAlert = nil;
			return NO;
		}
	}

	if (textField.keyboardType == UIKeyboardTypeDecimalPad)
	{
		if ([string isEqualToString:@"."])
		{
			NSString *tempString = [NSString stringWithFormat:@"%@", textField.text];
			NSInteger times = [[tempString componentsSeparatedByString:@"."] count]-1;
			if (times == 1)
				return NO;
		}
	}

	return YES;
}


#pragma mark
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}


#pragma mark
#pragma mark - UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UIView * txt in self.view.subviews)
		if (([txt isKindOfClass:[UITextField class]] || [txt isKindOfClass:[UITextView class]]) && [txt isFirstResponder])
			[txt resignFirstResponder];
}


#pragma mark
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return stateArray.count;
}


#pragma mark
#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [stateArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        statePickerView.frame = CGRectMake(0 , self.view.frame.size.height, self.view.frame.size.width, 250);
        [_selectStateButton setTitle:[stateArray objectAtIndex:row] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView commitAnimations];
    }];
}


#pragma mark
#pragma mark - Helper

- (void)textChanged:(NSNotification *)notification
{
	UITextField *textField = notification.object;
	if (textField.tag >= 11)
	{
		NSNumber *principleAmount = [NSNumber numberWithFloat:_loanAmountTextField.text.floatValue - _downPaymentTextField.text.floatValue];
		NSNumber *interestRate = [NSNumber numberWithFloat:_annualPercentRateTextField.text.floatValue];
		NSNumber *repayPeriod = [NSNumber numberWithInteger:_termsTextField.text.integerValue];
		
		[MonthlyPaymentCalculator monthlyPaymentForPrinciple:principleAmount atRate:interestRate forPeriod:repayPeriod resultBlock:^(NSDictionary *responseDict) {
			[_resultLabel setText:[responseDict objectForKey:@"result"]];
		}];
	}
}

- (void)locateAddress:(GeocoderResponseBlock)geocoderResponseBlock
{
	geocoder = [[CLGeocoder alloc] init];
	
	NSString *completeAddress = [NSString stringWithFormat:@"%@, %@, %@, %@, USA", _addressTextView.text, _cityTextField.text, _selectStateButton.titleLabel.text, _zipTextField.text];
	[geocoder geocodeAddressString:completeAddress completionHandler:^(NSArray *placemarks, NSError *error) {
		if (!error)
		{
			geocoderResponseBlock(placemarks);
		}
		else
		{
			geocoderResponseBlock([NSArray arrayWithObject:error]);
		}
	}];
}

- (void)fillLocationDetails:(Location *)location
{
    isEditing = YES;
    self.editingLocation = location;
    [_propertyTypeButton setTitle:location.propertyType forState:UIControlStateNormal];
    
    [_addressTextView setText:location.address];
    [_cityTextField setText:location.city];
    [_selectStateButton setTitle:@"Select state" forState:UIControlStateNormal];
    [_zipTextField setText:location.zip];
    [_loanAmountTextField setText:[NSString stringWithFormat:@"%@", location.loanAmount]];
    [_downPaymentTextField setText:[NSString stringWithFormat:@"%@", location.downPay]];
    [_annualPercentRateTextField setText:[NSString stringWithFormat:@"%@", location.apr]];
    [_termsTextField setText:[NSString stringWithFormat:@"%@", location.repayPeriod]];
    [_resultLabel setText:[NSString stringWithFormat:@"%.2f", location.monthlyPay.floatValue]];
}

- (void)performSaveOperation
{
    [self locateAddress:^(NSArray *responseArray) {
        if (![responseArray.lastObject isKindOfClass:[NSError class]])
        {
            if (responseArray.count > 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confused!" message:@"Address is ambiguous" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }
            else
            {
                NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc] init];
                [locationInfo setObject:(CLPlacemark *)responseArray.lastObject forKey:@"location"];
                [locationInfo setObject:_propertyTypeButton.titleLabel.text forKey:@"propertyType"];
                [locationInfo setObject:_addressTextView.text forKey:@"address"];
                [locationInfo setObject:_cityTextField.text forKey:@"city"];
                [locationInfo setObject:_selectStateButton.titleLabel.text forKey:@"state"];
                [locationInfo setObject:_zipTextField.text forKey:@"zip"];
                [locationInfo setObject:_loanAmountTextField.text forKey:@"loanAmount"];
                [locationInfo setObject:_downPaymentTextField.text forKey:@"downPayment"];
                [locationInfo setObject:_annualPercentRateTextField.text forKey:@"APR"];
                [locationInfo setObject:_termsTextField.text forKey:@"repayPeriod"];
                [locationInfo setObject:_resultLabel.text forKey:@"monthly"];
                
                [QueryManager saveLocation:locationInfo completionBlock:^(BOOL isSuccess) {
                    if (isSuccess)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Record saved successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                        [self newButtonClicked:nil];
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Record not saved. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                    }
                }];
                
                locationInfo = nil;
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not able to find the address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    }];
}


@end