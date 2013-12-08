//
//  tableViewController.m
//  ifinder
//
//  Created by pablete on 07/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "tableViewController.h"
#import "principalViewController.h"

@interface TableViewController ()
@end

@implementation TableViewController

NSMutableArray * zonasMutableArray;
NSMutableArray * elegidosArray;
//@synthesize zonasMutableArray;
//@synthesize elegidosArray;

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
    //NSInteger *Contador;
    //Contador=0;
	// Do any additional setup after loading the view.
    zonasMutableArray = [[NSMutableArray alloc]init];
    elegidosArray=[[NSMutableArray alloc]init];
    //self.title = @"zonas";´
    //self.botonEditarBarButtonItem.enabled=NO;
    //self.botonEditarBarButtonItem.title=@"";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *fooPath = [documentsPath stringByAppendingPathComponent:@"PuntosList.plist"];
    NSLog(@"%@",fooPath);
    zonasMutableArray  = [NSMutableArray arrayWithContentsOfFile:fooPath];
    NSLog(@"%d Registros recuperados en PuntosList.plist",zonasMutableArray.count);
    NSLog(@"array %@ ",zonasMutableArray);
   /* NSInteger *Contador = [self.zonasMutableArray count];
    if (Contador==0)
    {
        NSLog(@"El contador vale %d", Contador);
        self.zonasMutableArray  =  [ [ NSMutableArray  alloc ]  init ] ;
        for (int i=1; i<=5; i++)
        {
            [self.zonasMutableArray addObject: [ NSString  stringWithFormat: @ "Opción% i" , i ] ] ;
        }
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%d registros en zonasMutableArray",zonasMutableArray.count );
    return zonasMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CelldePuntos *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.CellX.text=[[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"x"] stringValue];
    cell.CellY.text=[[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"y"] stringValue];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    cell.CellFecha.text= [df stringFromDate:[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"fecha"]];
    if([self.elegidosArray containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
*/
//cell.tag=indexPath.row;
// Configure the cell...
    return cell;
}


#pragma mark - Prepare for sEgue


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToDetalle"])
    {
            }
    else if([segue.identifier isEqualToString:@"GoToNew"])
    {
    }
}
#pragma mark - Table view delegate

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [elegidosArray addObject:indexPath];
        
        NSLog(@"%d registros selecionados", elegidosArray.count);
        self.botonEditarBarButtonItem.enabled=YES;
        
        self.botonEditarBarButtonItem.title=@"Acción";
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [elegidosArray removeObject:indexPath];
        NSLog(@"celda borrada.. ");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPatH{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero] ;
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
}


#pragma mark - Boton Editar.
// pregunta si la tableview es editable.
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// metodo que se ejecuta al pulsar el boton borrar en estado de edicion.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [zonasMutableArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        if ([zonasMutableArray count] ==0)
        {
            [self.tableView setEditing:NO animated:YES];
            //self.botonEditarBarButtonItem.tag=0;
            //self.botonEditarBarButtonItem.title=@"";
            //self.botonEditarBarButtonItem.style=UIBarButtonItemStyleBordered;
            //self.botonEditarBarButtonItem.enabled=NO;
        }
        NSLog(@"registros en tableview %d",[zonasMutableArray count]);
        [self salvarplist];
    }
}
#pragma mark -salvado plist.
- (void) salvarplist
{
    
    NSString *rootPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // busca el fichero plist concreto.
    NSString *path_a_plist =[rootPath stringByAppendingPathComponent:@"PuntosList.plist"];
    NSLog(@"Ruta al fichero: %@", path_a_plist);
    // ya funciona...
    NSData *ficheroPlist;
    

    
    ficheroPlist =[NSPropertyListSerialization dataFromPropertyList:zonasMutableArray format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
    
    if (ficheroPlist)
    {
        
        [ficheroPlist writeToFile:path_a_plist atomically:YES];
        NSLog(@"grabando fichero...");
    }

}

#pragma mark - marcando


#pragma mark - IBAction
/*- (IBAction)EditarListado:(id)sender
{
    UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:@"Acciones..."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancelar"
                                              destructiveButtonTitle:@"Borrar todos los puntos"
                                                   otherButtonTitles:@"Pintar puntos en mapa", nil];
    [myActionSheet showInView:self.view];

}
*/
- (IBAction)volver:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex: (NSInteger )buttonIndex
{
    
    NSLog(@"ButtonsIndex: %d",buttonIndex);
    
    if (buttonIndex==[actionSheet cancelButtonIndex]) //2
    {
        NSLog(@"Cancelled");//2
    }
    
    if (buttonIndex == [actionSheet firstOtherButtonIndex])//1
    {
        NSLog(@"primer boton de otros: %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
        //
        // aqui enviar elegidosArray al mapkit para que pinte los puntos en el y regresar al mapkit.
        //
        //
        //principalViewController * vistadepaso= (principalViewController)segue.sender (id)sender
        
    }
        if (buttonIndex == 0)
    {
        NSLog(@"boton 0 borrando todos...");
        zonasMutableArray = [[NSMutableArray alloc]init];
        elegidosArray=[[NSMutableArray alloc] init];
        
        [self salvarplist];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}*/



@end
