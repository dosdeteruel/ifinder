//
//  principalViewController.m
//  ifinder
//
//  Created by German Bonilla Monterde on 29/10/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "principalViewController.h"

@interface principalViewController ()

@end

UIView *brujula;

CGRect screen;


@implementation principalViewController
@synthesize compassImage;


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
    
    screen = [[UIScreen mainScreen]bounds];
    angulo =0;
    
    
}
-(IBAction) cambiarAngulo:(id)sender{
    UIButton *botonGrados = (UIButton *) sender;
    int tagHoyo = botonGrados.tag;
    
    if (tagHoyo == 1) {
    
        angulo-=5.0;
    } else {
        angulo+=5.0;
    }
    [self dibujaBrujula];
    NSLog(@"angulo : %f", angulo);
}

-(void) dibujaBrujula{
    float rad = angulo * M_PI / 180.0f;
    self.compassImage.center = CGPointMake(self.compassImage.center.x, self.compassImage.center.y);
    self.compassImage.transform = CGAffineTransformMakeRotation (rad);
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
