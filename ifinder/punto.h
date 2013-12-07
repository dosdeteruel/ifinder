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
    NSString *fecha;
    //NSDate *fecha;
    
}

@property (nonatomic,retain) NSNumber *x;
@property (nonatomic,retain) NSNumber *y;
@property (nonatomic,retain) NSString *fecha;



@end
