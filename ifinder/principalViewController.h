//
//  principalViewController.h
//  ifinder
//
//  Created by German Bonilla Monterde on 29/10/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface principalViewController : UIViewController{
    float angulo;
}
@property (weak, nonatomic) IBOutlet UIImageView *compassImage;

-(IBAction) cambiarAngulo:(id)sender;


@end
