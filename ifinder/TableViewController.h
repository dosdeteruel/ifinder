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

@interface TableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIActionSheetDelegate>
{
    NSMutableArray *arOptions;
    NSMutableArray *contentArray;
    NSMutableArray *zonasMutableArray;
    
    
}


@property (nonatomic,strong) IBOutlet UIBarButtonItem *botonEditarBarButtonItem;

@property (nonatomic,strong) NSMutableArray *zonasMutableArray,*contentArray;

- (IBAction)EditarListado:(id)sender;


@end

