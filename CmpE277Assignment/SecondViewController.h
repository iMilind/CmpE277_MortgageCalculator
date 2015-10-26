//
//  SecondViewController.h
//  CmpE277Assignment
//
//  Created by Sushanta Sahoo on 4/21/15.
//  Copyright (c) 2015 Sushanta Sahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMapsM4B/GoogleMaps.h>

@interface SecondViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end