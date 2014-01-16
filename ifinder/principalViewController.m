//
//  principalViewController.m
//  ifinder
//
//  Created by German Bonilla Monterde on 29/10/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "principalViewController.h"
#import "puntoAnotacion.h"
@interface principalViewController()
{


}
@end

UIView *brujula;

CGRect screen;

@implementation principalViewController
@synthesize latitudLabel;
@synthesize longitudLabel;
@synthesize distanciaLabel;
@synthesize rumboLabel;
@synthesize locationManager;
@synthesize mapaView;
@synthesize mipuntodetalle;
NSUserDefaults *userDefaults;
int tipoAccion;

typedef NS_ENUM(NSInteger, TipoPuntoDef){
    hacerNada=0,
    irPunto = 1,
    irCoche = 2,
    guardaPunto=3,
    guardaCoche=4,
    pintarPunto=5
};

NSMutableArray *arrayPuntos;
NSString *nombrezona;
double miRumbo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locationManager=[[CLLocationManager alloc] init];
    
       locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      locationManager.distanceFilter=1;

    
    // Establecemos al propio controlador como el delegado de localización.
    locationManager.delegate=self;

    [locationManager startUpdatingHeading];
    self.mapaView.showsUserLocation = YES;
    tipoAccion=hacerNada;
    
 if (mipuntodetalle)
 {
     // pintar punto
    
     CLLocationCoordinate2D punto;  //= [[CLLocationCoordinate2D alloc] init];
     double x;
     double y;
     
     //   texto = [elPunto.fecha];
     
     x = [mipuntodetalle.x doubleValue];
     punto.longitude = x;
     
     y = [mipuntodetalle.y doubleValue];
     punto.latitude= y;
     
     
     puntoAnotacion *elpunto =[[puntoAnotacion alloc] initWithTitle: @"punto"
                               
                                                      andCoordinate:punto];
     [[NSUserDefaults standardUserDefaults] setFloat:y forKey:@"puntolatitud"];
     [[NSUserDefaults standardUserDefaults] setFloat:x forKey:@"puntolongitud"];
     
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     [self.mapaView addAnnotation:elpunto];
 
     tipoAccion=pintarPunto;
     [locationManager startUpdatingLocation];
   
     
     
 }
     else
     {
         
         
        }
 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    
    NSLog(@"angulo: %f",miRumbo);
   
   
 
    self.compassImage.transform = CGAffineTransformMakeRotation ((miRumbo-newHeading.trueHeading) * M_PI / 180);
    
    
        rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
   
    punto *miPunto =[[punto alloc] init];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd.MM.yyyy hh:mm:ss Z"];
    NSDate * fecha =[[NSDate alloc] init];
  
    double posx;
    double posy;
    
    
    CLLocation *location =[locations lastObject];
    NSDate *eventDate =location.timestamp;
    NSTimeInterval transcurrido=[eventDate timeIntervalSinceNow];
    if (abs(transcurrido) < 15.0) {
        // es reciente
    }
        posy= location.coordinate.latitude;
        posx =location.coordinate.longitude;
        
        self.latitudLabel.text =[NSString stringWithFormat:@"%f", posy];
        self.longitudLabel.text = [NSString stringWithFormat:@"%f", posx];
        
        
        NSLog(@"Latitud: %f Longitud: %f",  posy, posx);
        
        MKCoordinateRegion region;
          region.span = MKCoordinateSpanMake(0.005, 0.005);
     //   region.center = location.coordinate;
    
    region.center = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                locationManager.location.coordinate.longitude);
    
    
    [mapaView setRegion:region];
    self.mapaView.showsUserLocation = YES;
    
  
    NSLog(@"entrando");
    
    switch (tipoAccion) {
            
            
        case hacerNada:
              [locationManager stopUpdatingLocation];
            break;
            
        case irPunto:
            //ahora comprobar si hay que coger
            [self calculaelRumbo:location];
            
      
            rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
            
            break;
        case irCoche:
            //ahora comprobar si hay que coger
            
         [self calculaelRumbo:location];
            NSLog(@"rumbo: %f",miRumbo);
           [self Calculadistancia];
         
            rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
            
            
            break;
            
        case guardaPunto:
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            //guardar en plist
         
            miPunto.x = [NSNumber numberWithDouble:posx];
            miPunto.y = [NSNumber numberWithDouble:posy];
            
            fecha=[NSDate date];
            
            miPunto.fecha= [df stringFromDate:fecha];
            
            [arrayPuntos addObject:miPunto];

           
            [self volcarArrayPlist:miPunto];
          
            
            break;
            
        case guardaCoche:
            
            [[NSUserDefaults standardUserDefaults] setFloat:posy forKey:@"cochelatitud"];
            [[NSUserDefaults standardUserDefaults] setFloat:posx forKey:@"cochelongitud"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
           
            miPunto.x = [NSNumber numberWithDouble:posx];
            miPunto.y = [NSNumber numberWithDouble:posy];
            self.cocheGuardadoImage.alpha=1;
            
            break;
            
        case pintarPunto:
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            
            break;
            
    }
  
    
}


- (MKAnnotationView *) mapView: (MKMapView *) mapaView viewForAnnotation: (id) annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapaView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"];
    } else {
        pin.annotation = annotation;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    
    return pin;
}


- (void) calculaelRumbo:(CLLocation *)posicion
{
    
    NSString *punto;
    
    CLLocationCoordinate2D puntoInicio;
    CLLocationCoordinate2D puntoFin;
    
    puntoInicio.latitude = posicion.coordinate.latitude;
    puntoInicio.longitude = posicion.coordinate.longitude;
    
    
       if (tipoAccion==irPunto)
    {
        puntoFin.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"puntolatitud"];
        puntoFin.longitude= [[NSUserDefaults standardUserDefaults] doubleForKey:@"puntolongitud"];
        
       punto = @"Punto";
    }
    else if (tipoAccion==irCoche)
    {
        puntoFin.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"cochelatitud"];
        puntoFin.longitude= [[NSUserDefaults standardUserDefaults] doubleForKey:@"cochelongitud"];
          punto = @"Coche";
        
    }
    
       puntoAnotacion *elpunto =[[puntoAnotacion alloc] initWithTitle: punto
                                  
                                                         andCoordinate:puntoFin];
   
       [self.mapaView addAnnotation:elpunto];
    
   
    float uLat = (puntoInicio.latitude * M_PI)/ 180.0;
    float uLng = (puntoInicio.longitude * M_PI)/ 180.0;
    
    float fLat = (puntoFin.latitude *  M_PI)/ 180.0;
    float fLng = (puntoFin.longitude * M_PI)/ 180.0;
    
    miRumbo =  atan2(sin(fLng-uLng)*cos(fLat), cos(uLat)*sin(fLat)-sin(uLat)*cos(fLat)*cos(fLng-uLng));
    miRumbo = (miRumbo * 180.0 /M_PI);
    
    
    if (miRumbo >=0) {
                 }
          else {
             miRumbo = miRumbo  + 360;
         }
    
    NSLog(@"angulo: %f",miRumbo);
    self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
    self.compassImage.transform = CGAffineTransformMakeRotation ((miRumbo) * M_PI / 180);
    
    rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
  
   }



- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
    
    
    
}
- (void)showMessageCoche{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Coche guardado"
                                                      message:@"Pulse OK para continuar"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)showMessagePunto{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Punto guardado"
                                                      message:@"Pulse OK para continuar"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}


- (IBAction)iraAlgo{
    
    self.iraView.hidden=NO;
    self.iraView.alpha=1;
    [self.iraCocheButton setEnabled:YES];
    self.iraCocheButton.alpha =1;
    [self.iraPuntoButton setEnabled:YES];
    self.iraPuntoButton.alpha =1;
    self.iraCochelabel.alpha =1;
    self.iraPuntolabel.alpha =1;
    self.queQuieresHacerlabel.alpha =1;
    [self.cerrarIraAlgoButton setEnabled:YES];
    self.cerrarIraAlgoButton.alpha=1;
    
    
}

- (IBAction)iraCoche
{
    self.iraView.hidden=YES;
    self.iraView.alpha=0;
    [self.iraCocheButton setEnabled:NO];
    self.iraCocheButton.alpha =0;
    [self.iraPuntoButton setEnabled:NO];
    self.iraPuntoButton.alpha =0;
    self.iraCochelabel.alpha =0;
    self.iraPuntolabel.alpha =0;
    self.queQuieresHacerlabel.alpha =0;
    [self.cerrarIraAlgoButton setEnabled:NO];
    self.cerrarIraAlgoButton.alpha=0;
    
    tipoAccion=irCoche;  // ¡r coche
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
}
- (IBAction)iraPunto
{
    self.iraView.hidden=YES;
    self.iraView.alpha=0;
    [self.iraCocheButton setEnabled:NO];
    self.iraCocheButton.alpha =0;
    [self.iraPuntoButton setEnabled:NO];
    self.iraPuntoButton.alpha =0;
    self.iraCochelabel.alpha =0;
    self.iraPuntolabel.alpha =0;
    self.queQuieresHacerlabel.alpha =0;
    [self.cerrarIraAlgoButton setEnabled:NO];
    self.cerrarIraAlgoButton.alpha=0;
    
    tipoAccion=irCoche;  // ¡r coche
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
}
- (IBAction)cerrarIraAlgoButton:(id)sender {
    self.iraView.hidden=YES;
    self.iraView.alpha=0;
    [self.iraCocheButton setEnabled:NO];
    self.iraCocheButton.alpha =0;
    [self.iraPuntoButton setEnabled:NO];
    self.iraPuntoButton.alpha =0;
    self.iraCochelabel.alpha =0;
    self.iraPuntolabel.alpha =0;
    self.queQuieresHacerlabel.alpha =0;
    [self.cerrarIraAlgoButton setEnabled:NO];
    self.cerrarIraAlgoButton.alpha=0;
    
    tipoAccion=hacerNada;  // ¡r coche
}

- (IBAction)marcaCoche
{
    
    tipoAccion=guardaCoche;  //punto marcar coche
    self.showMessageCoche;
    [locationManager startUpdatingLocation];
}

- (IBAction)marcaPunto
{
    tipoAccion=guardaPunto;  //punto marcar coche
    self.showMessagePunto;
    [locationManager startUpdatingLocation];
    
}


#pragma mark - funciones
- (void) Calculadistancia
{
    CLLocationCoordinate2D puntoFin ;
    if (tipoAccion==irPunto)
    {
        puntoFin.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"puntolatitud"];
        puntoFin.longitude= [[NSUserDefaults standardUserDefaults] doubleForKey:@"puntolongitud"];
    }
    else if (tipoAccion==irCoche)
    {
        puntoFin.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"cochelatitud"];
        puntoFin.longitude= [[NSUserDefaults standardUserDefaults] doubleForKey:@"cochelongitud"];
    }
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:puntoFin.latitude longitude:puntoFin.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:self.mapaView.userLocation.coordinate.latitude longitude:self.mapaView.userLocation.coordinate.longitude];
    
    
    CLLocationDistance dist = [loc distanceFromLocation:loc2];
    if (dist > 1000)
    {
        dist = dist /1000;
        distanciaLabel.text = [[NSString stringWithFormat:@"%f",dist] stringByAppendingString:@"  metros"] ;
    }
    else
    {
        distanciaLabel.text = [[NSString stringWithFormat:@"%f",dist] stringByAppendingString:@" Km"] ;
    }
    NSLog(@"DIST: %f", dist);
}


- (void) volcarArrayPlist:(punto *) miPunto
{

    NSString *ruta;
    NSString *pathArray =    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDictionary *plistDictionary;
    ruta= [pathArray stringByAppendingPathComponent:@"PuntosList.plist"];
    if (ruta)
    {
        plistDictionary = [NSDictionary dictionaryWithObjects:
                           [NSArray arrayWithObjects: miPunto.fecha, miPunto.x, miPunto.y, nil] forKeys:
                           [NSArray arrayWithObjects:@"fecha",@"x",@"y",nil]
                           ];
     // recogo datos del fichero a ver si tiene algo
        NSMutableArray* plistArray = [[NSMutableArray alloc] initWithContentsOfFile:ruta];
        if(plistArray)
            
        {
            [plistArray addObject: plistDictionary];
            BOOL success = [plistArray writeToFile: ruta atomically: YES];
            if( success == NO)
            {
               
            }
            else
            {
               
            }
        }
        else
        {
        
            NSMutableArray  *plistvacio = [[NSMutableArray alloc] init];
            [plistvacio addObject: plistDictionary];
            BOOL success = [plistvacio writeToFile: ruta atomically: YES];
            if( success == NO)
            {
                            }
            else
            {
                            }
        }
    }
    
}

- (void) pintarPunto:(punto *) elPunto
{
  
    CLLocationCoordinate2D punto;
    double x;
    double y;
    
    
    x = [elPunto.x doubleValue];
    punto.longitude = x;
    
    y = [elPunto.y doubleValue];
    punto.longitude = y;
    
    puntoAnotacion *elpunto =[[puntoAnotacion alloc] initWithTitle: @"punto"
                                                     andCoordinate:punto];
    [self.mapaView addAnnotation:elpunto];
}

- (void) pintarArrayPuntos:(NSMutableArray *) losPuntos
{
    NSString *texto;
    CLLocationCoordinate2D punto;
    double x;
    double y;
    
    for (NSDictionary *unpunto in losPuntos)
    {
        texto = [unpunto objectForKey:@"fecha"];
        
        x = [[unpunto objectForKey:@"x"] doubleValue];
        punto.longitude = x;
        
        y = [[unpunto objectForKey:@"y"] doubleValue];
        punto.longitude = y;

        puntoAnotacion *elpunto =[[puntoAnotacion alloc] initWithTitle: @"punto"
                                                         andCoordinate:punto];
        [self.mapaView addAnnotation:elpunto];
    }
}



- (IBAction)irTabla:(id)sender
{
}

@end
