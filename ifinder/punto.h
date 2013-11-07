//
//  punto.h
//  ifinder
//
//  Created by pablete on 07/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface punto : NSObject
{
    NSNumber *x;
    NSNumber *y;
    NSNumber *fecha;
    NSString *dato;
    NSString *zona;
    NSString *imagen;
}

@property (nonatomic,retain) NSNumber *x;
@property (nonatomic,retain) NSNumber *y;
@property (nonatomic,retain) NSNumber *fecha;
@property (nonatomic,retain) NSString *dato;
@property (nonatomic,retain) NSString *zona;
@property (nonatomic,retain) NSString *imagen;


@end
