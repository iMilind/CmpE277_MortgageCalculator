//
//  SecondViewController.m
//  CmpE277Assignment
//
//  Created by Sushanta Sahoo on 4/21/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import "SecondViewController.h"
#import <GoogleMapsM4B/GoogleMaps.h>
#import <GoogleMapsM4B/GMSMarker.h>
#import <MapKit/MapKit.h>
#import "QueryManager.h"
#import "Location.h"
#import "MarkerInfoView.h"
#import "FirstViewController.h"



@interface SecondViewController () <GMSMapViewDelegate>

@property (strong) CLLocationManager *locationManager;
@property NSMutableArray *locations;
@property (strong) Location *deleteLocation;
@property (strong) UIView *streetViewContainer;
@property (strong) UIButton *exitButton;

@end


@implementation SecondViewController


#pragma mark
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	_mapView.delegate = self;
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
	if (!self.locationManager)
		_locationManager = [[CLLocationManager alloc] init];

	self.locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[_locationManager requestWhenInUseAuthorization];
	GMSCameraPosition *userLocationCamera = [GMSCameraPosition cameraWithLatitude:37.33 longitude:-121.90 zoom:11];
	_mapView.camera = userLocationCamera;
    
    [self reloadMapView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
}


#pragma mark
#pragma mark - CLLocationManagerDelegate

- (void)addAnnotation:(Location *)location
{
	CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
	
	GMSMarker *marker = [[GMSMarker alloc] init];
    marker.draggable = YES;
	marker.userData = location;
	marker.appearAnimation = kGMSMarkerAnimationPop;
	marker.opacity = 0.5;
	marker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude);
	marker.map = _mapView;
}


#pragma mark
#pragma mark - GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
	MarkerInfoView *calloutView = [[MarkerInfoView alloc] init];
	
	calloutView.location = marker.userData;
	calloutView.propertyTypeLabel.text = [(Location *)marker.userData propertyType];
	calloutView.addressLabel.text = [NSString stringWithFormat:@"%@, %@", [(Location *)marker.userData address], [(Location *)marker.userData city]];
	calloutView.paymentLabel.text = [NSString stringWithFormat:@"%.2f @%.2f%% %.2f per month", [[(Location *)marker.userData loanAmount] floatValue], [[(Location *)marker.userData apr] floatValue], [[(Location *)marker.userData monthlyPay] floatValue]];

	return calloutView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    self.deleteLocation = (Location *)marker.userData;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select one" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", @"Street View", @"Edit", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void)exitStreetViewButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        [_streetViewContainer removeFromSuperview];
        _streetViewContainer = nil;
        [_mapView setHidden:NO];
    } completion:^(BOOL finished) {
        [UIView commitAnimations];
    }];

}


#pragma mark
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", self.deleteLocation.objectID);
    if (buttonIndex == 1)
    {
        /** Delete  */
        [QueryManager deleteLocation:self.deleteLocation onCompletion:^(BOOL isSuccess) {
            
            if (isSuccess)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully Deleted!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                alert = nil;
            }
        }];

        [self reloadMapView];
    }
    if (buttonIndex == 2)
    {
        /** Street View */
        [UIView animateWithDuration:0.5 animations:^{
            [_mapView setHidden:YES];
            
            _streetViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height, _imageView.frame.size.width, self.view.frame.size.height-_imageView.frame.size.height)];
            
            CLLocationCoordinate2D panoramaNear = {_mapView.selectedMarker.position.latitude,_mapView.selectedMarker.position.longitude};
            
            GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:_streetViewContainer.bounds nearCoordinate:panoramaNear];
            
            _streetViewContainer = panoView;
            [self.view addSubview:_streetViewContainer];
            
            UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [exitButton setFrame:CGRectMake(20, 20, _streetViewContainer.frame.size.width-40, 40)];
            [exitButton setTitle:@"Exit street view" forState:UIControlStateNormal];
            [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [exitButton addTarget:self action:@selector(exitStreetViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_streetViewContainer addSubview:exitButton];
        } completion:^(BOOL finished) {
            [UIView commitAnimations];
        }];
    }
    if (buttonIndex == 3)
    {
        /** Edit    */
        [self.tabBarController setSelectedIndex:0];
        [(FirstViewController *)[self.tabBarController.viewControllers objectAtIndex:0] fillLocationDetails:self.deleteLocation];
    }

    self.deleteLocation = nil;
}


- (void)reloadMapView
{
    [_mapView clear];
    _locations = [[NSMutableArray alloc] initWithArray:[QueryManager fetchAllLocations]];
    
    for (Location *location in _locations)
        [self addAnnotation:location];
}


@end