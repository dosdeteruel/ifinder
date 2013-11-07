//
//  principalViewController.h
//  ifinder
//
//  Created by German Bonilla Monterde on 29/10/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "punto.h"


@interface principalViewController : UIViewController <CLLocationManagerDelegate>
{
}

@property (retain,nonatomic) IBOutlet UILabel *latitudLabel;
@property (retain,nonatomic) IBOutlet UILabel *longitudLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UIImageView *compassImage;

- (double) calculaRumbo:(double) lat longitud:(double) lon;
- (double) calculaelRumbo:(CLLocation *)posicion;
- (IBAction)iraCoche;
- (IBAction)marcaCoche;
- (IBAction)marcaPunto;
- (void) guardarAPlist:(punto *) miPunto;


@end
