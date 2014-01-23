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
#import "TableViewController.h"


@interface principalViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
   
   }

@property (retain,nonatomic) IBOutlet UILabel *latitudLabel;
@property (retain,nonatomic) IBOutlet UILabel *longitudLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UIImageView *compassImage;
@property (strong, nonatomic) IBOutlet UILabel *distanciaLabel;

@property (retain, nonatomic) IBOutlet UILabel *queQuieresHacerlabel;
@property (retain, nonatomic) IBOutlet UILabel *iraCochelabel;
@property (retain, nonatomic) IBOutlet UILabel *iraPuntolabel;
@property (retain, nonatomic) IBOutlet UIButton *iraCocheButton;
@property (retain, nonatomic) IBOutlet UIButton *iraPuntoButton;
@property (retain, nonatomic) IBOutlet UIView *iraView;
@property (weak, nonatomic) IBOutlet UIButton *cerrarIraAlgoButton;
@property (nonatomic,strong) punto *mipuntodetalle;
@property (weak, nonatomic) IBOutlet UIImageView *cocheGuardadoImage;
- (IBAction)irTabla:(UIStoryboard *)segue;

@property (nonatomic, retain) IBOutlet UILabel *rumboLabel;
@property (retain, nonatomic) IBOutlet MKMapView *mapaView;


- (void) calculaelRumbo:(CLLocation *)posicion;
- (IBAction)iraCoche;
- (IBAction)iraPunto;
- (IBAction)iraAlgo;
- (IBAction)marcaCoche;
- (IBAction)marcaPunto;
- (void)showMessageCoche;
- (void)showMessagePunto;
- (void)showMessageMeta;
- (void) Calculadistancia;

- (void) pintarArrayPuntos:(NSMutableArray *) losPuntos;

- (void) volcarArrayPlist:(punto *) miPunto;



@end
