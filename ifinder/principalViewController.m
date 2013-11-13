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
    
    // El ángulo mínimo que debe cambiar para que se actualize el valor y así iOS informe al sistema del cambio.
    locationManager.headingFilter = 0;
    
    // Establecemos al propio controlador como el delegado de localización.
    locationManager.delegate=self;
    
    // Al igual que con los ángulos, con la posición ponemos que se avise de cambios en cuanto haya uno mínimo.
    locationManager.distanceFilter = 1;
    
    
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
    
    // Convertimos a Radianes el angulo anterior y el nuevo.
    
 //  float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    
 //   float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    
    // Creamos una animación.
 //   CABasicAnimation *theAnimation;
    
    // Será de tipo rotación
  //  theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    // Establecemos los valores del giro.
  //  theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    
  //  theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    
    // Podemos poner una duración, pero puede resultar retrasado si ponemos tiempo.
  //  theAnimation.duration = 0.0;



  //  self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
  //  self.compassImage.transform = CGAffineTransformMakeRotation (newRad);
    // Le aplicamos la animación a la imagen de la brújula.
 //   [compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    
 //   compassImage.transform = CGAffineTransformMakeRotation(newRad);
  //  float angulo =  (miRumbo * M_PI) / 180.0;
    
    NSLog(@"angulo: %f",miRumbo);
    self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
    self.compassImage.transform = CGAffineTransformMakeRotation ((miRumbo-newHeading.trueHeading) * M_PI / 180);
 //   [self Calculadistancia];
    rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
   
    punto *miPunto;
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
          region.span = MKCoordinateSpanMake(0.1, 0.1);
        region.center = location.coordinate;
        
        
  
    NSLog(@"entrando");
    
    switch (tipoAccion) {
            
            
        case hacerNada:
            break;
            
        case irPunto:
            //ahora comprobar si hay que coger
            [self calculaelRumbo:location];
            
        //    NSLog(@"rumbo: %f",rumbo);
            rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
            
            break;
        case irCoche:
            //ahora comprobar si hay que coger
      
            
         [self calculaelRumbo:location];
            NSLog(@"rumbo: %f",miRumbo);
           [self Calculadistancia];
          //  rumboLabel.text = rumboLabel.text && [NSString stringWithFormat:@"%f",miRumbo];
            rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
            
            
            break;
            
        case guardaPunto:
            [[NSUserDefaults standardUserDefaults] setFloat:posy forKey:@"puntolatitud"];
            [[NSUserDefaults standardUserDefaults] setFloat:posx forKey:@"puntolongitud"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            tipoAccion=hacerNada;
            [locationManager stopUpdatingLocation];
            
            //guardar en plist
            miPunto.x = [NSNumber numberWithDouble:posx];
            miPunto.y = [NSNumber numberWithDouble:posy];
        
            [arrayPuntos addObject:miPunto];
            
            //guardo?? creo que si
            [self guardarAPlist: miPunto];
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
          
            //[arrayPuntos addObject:miPunto];
            
           // [self guardarAPlist: miPunto];
            break;
            
    }
    MKCoordinateRegion region2;
    region2.span = MKCoordinateSpanMake(0.2, 0.1);
    region2.center = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                               locationManager.location.coordinate.longitude);
    
    region2.center = location.coordinate;
    
    [mapaView setRegion:region2];
    self.mapaView.showsUserLocation = YES;

    
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

  
    
   
    float tLat = (puntoInicio.latitude * M_PI)/ 180.0;
    float tLng = (puntoInicio.longitude * M_PI)/ 180.0;
    
    float fLat = (puntoFin.latitude *  M_PI)/ 180.0;
    float fLng = (puntoFin.longitude * M_PI)/ 180.0;
  
    
    

  //  float tLat = (puntoInicio.latitude *  M_PI)/ 180.0;
  //  float tLng = (puntoInicio.longitude * M_PI)/ 180.0;
 //   float fLat = (puntoFin.latitude * M_PI)/ 180.0;
 //   float fLng = (puntoFin.longitude * M_PI)/ 180.0;
    
    //float degree= atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
 //   float tc= fmod(atan2(fLng-tLng,log(tan(tLat/2+M_PI/4)/tan(fLat/2+M_PI/4))),2*M_PI);
    //degree =  degree * 180.0 / M_PI;
    //if (degree >=0) {
      //  return degree;
        
    //}
    //else {
      //  return degree + 360;
    //}

    
    miRumbo = miRumbo + atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
   
    
    if (miRumbo >=0) {
        // return miRumbo;
          }
          else {
             miRumbo = miRumbo  + 360;
         }
    
    NSLog(@"angulo: %f",miRumbo);
    self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
   self.compassImage.transform = CGAffineTransformMakeRotation ((miRumbo) * M_PI / 180);
    
    
    
    
    //   [self Calculadistancia];
    rumboLabel.text = [NSString stringWithFormat:@"%f",miRumbo];
    
    
    
    
    
    
    
    
//    degree =  degree * 180.0 / M_PI;
//   if (degree >=0) {
      // return miRumbo;
//   }
//   else {
//       return degree + 360;
//   }

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
        NSLog(@"DIST: %f", dist); // Wrong formatting may show wrong value!
    
    
   // distanciaLabel.text = [NSString  stringWithFormat:@"%f",dist];
    
    
    
}




- (void) guardarAPlist:(punto *)miPunto
{
    //
    //    NSMutableArray *zonaux = [[NSMutableArray alloc]init];
    //    NSDictionary *plistDictionary;
    NSData *plistData;
    NSString *ruta;
    NSString *pathArray =    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    ruta= [pathArray stringByAppendingPathComponent:@"PuntosList.plist"];
    
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

/*
- (NSMutableArray *) leerDePlist
{
    //puedo sacar solo las zonas
    // puedo saar los puntos de una zona
    int i;
    i=0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PuntosList" ofType:@"plist"];
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

*/
@end
