//
//  puntoAnotacion.m
//  ifinder
//
//  Created by Maria Jose Medrano on 10/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "puntoAnotacion.h"

@implementation puntoAnotacion

@synthesize title,  coordinate;
- (id)initWithTitle:(NSString *)aTitle andCoordinate:(CLLocationCoordinate2D)coord
{
	self = [super init];
	title = aTitle;
   	coordinate = coord;
	return self;
}
@end
