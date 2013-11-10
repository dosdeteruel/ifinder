//
//  puntoAnotacion.h
//  ifinder
//
//  Created by Maria Jose Medrano on 10/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface puntoAnotacion : NSObject <MKAnnotation> {
    
    // Creamos un título
    NSString *title;
     // Y una coordenada
    CLLocationCoordinate2D coordinate;
}


@property (nonatomic, copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)aTitle  andCoordinate:(CLLocationCoordinate2D)coord;


@end
