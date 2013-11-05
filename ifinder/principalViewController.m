//
//  principalViewController.m
//  ifinder
//
//  Created by German Bonilla Monterde on 29/10/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "principalViewController.h"

@interface principalViewController ()
{}
@end

@implementation principalViewController

@synthesize latitudLabel;
@synthesize longitudLabel;
@synthesize locationManager;
@synthesize compassImage;
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
    
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    nombrezona= [defaults stringForKey:@"zona"];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager=[[CLLocationManager alloc] init];
    
    // Establecemos la precisión como la mejor.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // El ángulo mínimo que debe cambiar para que se actualize el valor y así iOS informe al sistema del cambio.
    locationManager.headingFilter = 1;
    
    
    // Establecemos al propio controlador como el delegado de localización.
    locationManager.delegate=self;
    
    
    // Al igual que con los ángulos, con la posición ponemos que se avise de cambios en cuanto haya uno mínimo.
    locationManager.distanceFilter = 1;
    
    tipoAccion=hacerNada;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    // Convertimos a Radianes el angulo anterior y el nuevo.
    
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    
    
    // Creamos una animación.
    CABasicAnimation *theAnimation;
    
    // Será de tipo rotación
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    // Establecemos los valores del giro.
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    
    // Podemos poner una duración, pero puede resultar retrasado si ponemos tiempo.
    theAnimation.duration = 0.0;
    
    
    // Le aplicamos la animación a la imagen de la brújula.
    [compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    
    compassImage.transform = CGAffineTransformMakeRotation(newRad);
    
    
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    double rumbo;
    punto *miPunto;
    
    CLLocation *location =[locations lastObject];
    NSDate *eventDate =location.timestamp;
    NSTimeInterval transcurrido=[eventDate timeIntervalSinceNow];
    if (abs(transcurrido) < 15.0) {
        // es reciente
        
        self.latitudLabel.text =[NSString stringWithFormat:@"%f", location.coordinate.latitude];
        self.longitudLabel.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        
        NSLog(@"Latitud: %f Longitud: %f",  location.coordinate.latitude, location.coordinate.longitude);
        
        MKCoordinateRegion region;
        //  region.span = MKCoordinateSpanMake(0.1, 0.1);
        region.center = location.coordinate;
        
        
    }
    NSLog(@"entrando");
    
    switch (tipoAccion) {
            
            
        case hacerNada:
            
        case irPunto:
            //ahora comprobar si hay que coger
            rumbo = [self calculaelRumbo:location];
            
            NSLog(@"rumbo: %f",rumbo);
            
        case irCoche:
            //ahora comprobar si hay que coger
            rumbo = [self calculaelRumbo:location];
            
            NSLog(@"rumbo: %f",rumbo);
            
        case guardaPunto:
            [userDefaults setFloat:location.coordinate.latitude forKey:@"puntolatitud"];
            [userDefaults setFloat:location.coordinate.longitude forKey:@"puntolongitud"];
            
            [userDefaults synchronize];
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            //guardar en plist
            
            
            
            miPunto.x = [NSNumber numberWithDouble:location.coordinate.longitude];
            miPunto.y = [NSNumber numberWithDouble:location.coordinate.latitude];
            miPunto.zona = nombrezona;
            
            //   miPunto.fecha = [NSNumber numberWithInteger:NSDate date];
            //   miPunto.dato ="";
            [arrayPuntos addObject:miPunto];
            
            
            //guardo?? creo que si
            
            [self guardarAPlist: miPunto];
            
            
        case guardaCoche:
            [userDefaults setFloat:location.coordinate.latitude forKey:@"cochelatitud"];
            [userDefaults setFloat:location.coordinate.longitude forKey:@"cochelongitud"];
            
            [userDefaults synchronize];
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            
    }
    
    
    
}

- (double) calculaelRumbo:(CLLocation *)posicion
{
    
    CLLocationCoordinate2D puntoInicio;
    CLLocationCoordinate2D puntoFin;
    
    puntoInicio.latitude = posicion.coordinate.latitude;
    puntoInicio.longitude = posicion.coordinate.longitude;
    
    if (tipoAccion==irPunto)
    {
        puntoFin.latitude = [userDefaults doubleForKey:@"puntolatitude"];
        puntoFin.longitude= [userDefaults doubleForKey:@"puntolongitude"];
    }
    else if (tipoAccion==irCoche)
    {
        puntoFin.latitude = [userDefaults doubleForKey:@"cochelatitude"];
        puntoFin.longitude= [userDefaults doubleForKey:@"cochelongitude"];
        
        
    }
    
    float fLat = puntoInicio.latitude;
    float fLng = puntoInicio.longitude;
    float tLat = puntoFin.latitude;
    float tLng = puntoFin.longitude;
    
    return atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
    
    
    
    
}
- (IBAction)iraCoche
{
    tipoAccion=irCoche;  // ¡r coche
    [locationManager startUpdatingLocation];
    
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



- (double) calculaRumbo:(double) lat longitud:(double ) lon
{
    
    CLLocationCoordinate2D puntoInicio;
    CLLocationCoordinate2D puntoFin;
    
    puntoInicio.latitude = lat;
    puntoInicio.longitude = lon;
    
    puntoFin.latitude = [userDefaults doubleForKey:@"latitude"];
    puntoFin.longitude= [userDefaults doubleForKey:@"longitude"];
    
    
    //    x = atan2(cos(puntoInicio.latitude)*sin(puntoFin.latitude)-sin(puntoInicio.latitude)*cos(puntoFin.latitude)*cos(puntoFin.longitude-puntoInicio.longitude), sin(puntoFin.longitude-puntoInicio.longitude)*cos(puntoFin.latitude));
    
    float fLat = puntoInicio.latitude;
    float fLng = puntoInicio.longitude;
    float tLat = puntoFin.latitude;
    float tLng = puntoFin.longitude;
    
    //   NSLog(@"Bearing: %f", x); // bearing is 180
    
    return atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
    
    
}

- (void) Calculadistancia
{
    
    
    //   CLLocationCoordinate2D annocoord = annotation.coordinate;
    //   CLLocationCoordinate2D usercoord = self.mapView.userLocation.coordinate;
    
    //    NSLog(@"ANNO  = %f, %f", annocoord.latitude, annocoord.longitude);
    //    NSLog(@"USER = %f, %f", usercoord.latitude, usercoord.longitude);
    
    //    CLLocation *loc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    //    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
    
    //    NSLog(@"LOC  = %f, %f", loc.coordinate.latitude,  loc.coordinate.longitude);
    //    NSLog(@"LOC2 = %f, %f", loc2.coordinate.latitude, loc2.coordinate.longitude);
    
    //    CLLocationDistance dist = [loc distanceFromLocation:loc2];
    
    //    NSLog(@"DIST: %f", dist); // Wrong formatting may show wrong value!
}


- (void) guardarAPlist:(punto *)miPunto
{
    //
    //    NSMutableArray *zonaux = [[NSMutableArray alloc]init];
    //    NSDictionary *plistDictionary;
    NSData *plistData;
    NSString *ruta;
    NSString *pathArray =    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    ruta= [pathArray stringByAppendingPathComponent:@"zonas.plist"];
    
    NSArray *auxPunto=[[NSArray alloc] initWithObjects:miPunto.x, miPunto.y, miPunto.zona, nil ];
    
    
    //tengo el punto a guardar y la zona
    //si grabo solo un punto....
    
    
    
    
    
    NSError *error = [[NSError alloc]init];
    
    
    plistData = [NSPropertyListSerialization dataWithPropertyList:auxPunto format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    
    if (plistData)
    {
        [plistData writeToFile:ruta atomically:YES];
    }
    
    
    
}


- (NSMutableArray *) leerDePlist
{
    //puedo sacar solo las zonas
    // puedo saar los puntos de una zona
    int i;
    i=0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zonas" ofType:@"plist"];
    NSMutableArray *arrayzonas =[[NSMutableArray alloc] init];
    NSMutableArray *arraynombrezonas =[[NSMutableArray alloc] init];
    
    
    //Creamos un array con el contenido del fichero
    
    NSArray *arrayConDatos = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (; i < arrayConDatos.count; i++)
    {
        
        [arrayzonas addObject: [arrayConDatos objectAtIndex:i]];
        //  NSLog(@"elemento - %d en myArray: %@", i, element);
        [arraynombrezonas addObject:[arrayzonas objectAtIndex:2]];
        
    }
    
    
    return arraynombrezonas;
    
}



- (NSMutableArray *) leerDePlistunaZona: (NSString *) nombrezona
{
    
    
    int i;
    i=0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zonas" ofType:@"plist"];
    NSMutableArray *arrayzonas =[[NSMutableArray alloc] init];
    NSMutableArray *arraypuntoszonas =[[NSMutableArray alloc] init];
    
    
    //Creamos un array con el contenido del fichero
    
    NSArray *arrayConDatos = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (; i < arrayConDatos.count; i++)
    {
        
        [arrayzonas addObject: [arrayConDatos objectAtIndex:i]];
        //  NSLog(@"elemento - %d en myArray: %@", i, element);
        
        
        if ([arrayzonas objectAtIndex:2]== nombrezona)
        {
            [arraypuntoszonas addObject: [arrayzonas objectAtIndex:i]];
        }
        
        
        
    }
    
    
    return arraypuntoszonas;
    
    
    
    
    
}


@end
