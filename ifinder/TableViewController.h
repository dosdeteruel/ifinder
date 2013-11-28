//
//  tableViewController.h
//  ifinder
//
//  Created by pablete on 07/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "punto.h"
#import "principalViewController.h"
#import "CelldePuntos.h"

//@protocol pintarDsenMapa <NSObject>

//-(void)pintarRutasenMapa:(NSArray *)listadodepuntos;

//@end


@interface TableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray *elegidosArray;
    NSMutableArray *zonasMutableArray;
}

//@property (nonatomic,strong) id <pintarRutasenMapa> delegate;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *botonEditarBarButtonItem;

@property (nonatomic,strong) NSMutableArray * zonasMutableArray;
@property (nonatomic,strong) NSMutableArray * elegidosArray;

- (IBAction)EditarListado:(id)sender;

- (IBAction)volver:(id)sender;

@end

