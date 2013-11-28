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
NSUserDefaults *userDefaults;
int tipoAccion;

typedef NS_ENUM(NSInteger, TipoPuntoDef){
    hacerNada=0,
    irPunto = 1,
    irCoche = 2,
    guardaPunto=3,
    guardaCoche=4
};

NSMutableArray *arrayPuntos;
NSString *nombrezona;
double miRumbo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //nombrezona= [defaults stringForKey:@"zona"];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager=[[CLLocationManager alloc] init];
    
    // Establecemos la precisión como la mejor.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      locationManager.distanceFilter=1;

    // El ángulo mínimo que debe cambiar para que se actualize el valor y así iOS informe al sistema del cambio.
  //  locationManager.headingFilter = kCLDistanceFilterNone;
    
    // Establecemos al propio controlador como el delegado de localización.
    locationManager.delegate=self;
    
    // Al igual que con los ángulos, con la posición ponemos que se avise de cambios en cuanto haya uno mínimo.
  //  locationManager.distanceFilter = kCLDistanceFilterNone;
    
 //   MKCoordinateRegion region;
 //   region.span = MKCoordinateSpanMake(0.2, 0.1);
 //   region.center = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
 //                                              locationManager.location.coordinate.longitude);
    [locationManager startUpdatingHeading];
    self.mapaView.showsUserLocation = YES;
    tipoAccion=hacerNada;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    
    NSLog(@"angulo: %f",miRumbo);
   
   
 //   CLLocationDirection direccion = newHeading.magneticHeading;
 //   CGFloat radianes = -direccion / 180.0* M_PI;
    
    
    
 //   self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
  
    self.compassImage.transform = CGAffineTransformMakeRotation ((miRumbo-newHeading.trueHeading) * M_PI / 180);
    
    
        rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
   
    punto *miPunto =[[punto alloc] init];
    
  
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
      //  region.center = location.coordinate;
    
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
        //    [[NSUserDefaults standardUserDefaults] setFloat:posy forKey:@"puntolatitud"];
        //    [[NSUserDefaults standardUserDefaults] setFloat:posx forKey:@"puntolongitud"];
            
        //    [[NSUserDefaults standardUserDefaults] synchronize];
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            //guardar en plist
         
            miPunto.x = [NSNumber numberWithDouble:posx];
            miPunto.y = [NSNumber numberWithDouble:posy];
            miPunto.fecha= [NSDate date];

            [arrayPuntos addObject:miPunto];
            
            //guardo?? creo que si
        //    [self guardartodoAplist: miPunto];
            [self volcarArrayPlist:miPunto];
            
            break;
            
        case guardaCoche:
            
            [[NSUserDefaults standardUserDefaults] setFloat:posy forKey:@"cochelatitud"];
            [[NSUserDefaults standardUserDefaults] setFloat:posx forKey:@"cochelongitud"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            //añado el punto del coche al array
            miPunto.x = [NSNumber numberWithDouble:posx];
            miPunto.y = [NSNumber numberWithDouble:posy];
         //   miPunto.x = posx;
            
            //[arrayPuntos addObject:miPunto];
            
           // [self guardarAPlist: miPunto];
            break;
            
    }
  
    
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

- (IBAction)iraCoche
{
    tipoAccion=irCoche;  // ¡r coche
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
}
- (IBAction)marcaCoche
{
    
    tipoAccion=guardaCoche;  //punto marcar coche
    [locationManager startUpdatingLocation];
}

- (IBAction)marcaPunto
{
    tipoAccion=guardaPunto;  //punto marcar coche
    [locationManager startUpdatingLocation];
}


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
    
        NSLog(@"LOC  = %f, %f", loc.coordinate.latitude,  loc.coordinate.longitude);
        NSLog(@"LOC2 = %f, %f", loc2.coordinate.latitude, loc2.coordinate.longitude);
    
        CLLocationDistance dist = [loc distanceFromLocation:loc2];
    
    if (dist > 1000) {
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
        
        
        plistDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: miPunto.fecha, miPunto.x, miPunto.y, nil] forKeys:[NSArray arrayWithObjects:@"fecha",@"x",@"y",nil]];
     
        
        // recogo datos del fichero a ver si tiene algo
        NSMutableArray* plistArray = [[NSMutableArray alloc] initWithContentsOfFile:ruta];
        if(plistArray)
            
        {
            [plistArray addObject: plistDictionary];
            BOOL success = [plistArray writeToFile: ruta atomically: YES];
            if( success == NO)
            {
                NSLog( @"No grabo en plist" );
            }
            else{
                NSLog( @"Hecho plist" );
            }
       
       [self pintarArrayPuntos: plistArray];
            
            
            

        }
        else
        {
        
            NSMutableArray  *plistvacio = [[NSMutableArray alloc] init];
            [plistvacio addObject: plistDictionary];
            BOOL success = [plistvacio writeToFile: ruta atomically: YES];
            if( success == NO)
            {
                NSLog( @"No grabo en plist vacio" );
            }
            else{
                NSLog( @"Hecho plist desde vacio" );
            }
         

        
        }
    }
    
}
@end
