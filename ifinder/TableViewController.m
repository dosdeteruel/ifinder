//
//  tableViewController.m
//  ifinder
//
//  Created by pablete on 07/11/13.
//  Copyright (c) 2013 German Bonilla Monterde. All rights reserved.
//

#import "tableViewController.h"

@interface TableViewController ()

@end



NSMutableArray *zonasMutableArray;


@implementation TableViewController
@synthesize zonasMutableArray;
@synthesize contentArray;
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
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fondo-campo.jpg"]]];
    self.zonasMutableArray = [[NSMutableArray alloc]init];
    self.contentArray=[[NSMutableArray alloc]init];
    //self.title = @"zonas";´
    self.botonEditarBarButtonItem.enabled=NO;
    self.botonEditarBarButtonItem.title=@"";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *fooPath = [documentsPath stringByAppendingPathComponent:@"PuntosList.plist"];
    NSLog(@"%@",fooPath);
    self.zonasMutableArray  = [NSMutableArray arrayWithContentsOfFile:fooPath];
    NSLog(@"%d Registros recuperados en PuntosList.plist",self.zonasMutableArray.count);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%d registros en zonasMutableArray", self.zonasMutableArray.count );
    return self.zonasMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CelldePuntos *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //NSNumber * numero=[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"x"];
    //=[ numero stringValue ];
    cell.CellX.text=[[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"x"] stringValue];
    cell.CellY.text=[[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"y"] stringValue];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    cell.CellDate.text= [df stringFromDate:[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"fecha"]];
    
    if([self.contentArray containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.contentArray addObject:indexPath];
        
        NSLog(@"%d registros seled", self.contentArray.count);
        self.botonEditarBarButtonItem.enabled=YES;
        
        self.botonEditarBarButtonItem.title=@"Acción";
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.contentArray removeObject:indexPath];
        NSLog(@"celda borrada.. :-(");
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [self.zonasMutableArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        if ([self.zonasMutableArray count] ==0)
        {
            [self.tableView setEditing:NO animated:YES];
            self.botonEditarBarButtonItem.tag=0;
            self.botonEditarBarButtonItem.title=@"Editar";
            self.botonEditarBarButtonItem.style=UIBarButtonItemStyleBordered;
            self.botonEditarBarButtonItem.enabled=NO;
        }
    }
}
#pragma mark - marcando


#pragma mark - IBAction
- (IBAction)EditarListado:(id)sender
{
    UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:@"Acciones"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Borrar Todos"
                                                   otherButtonTitles:@"Pintar puntos en mapa", nil];///
    [myActionSheet showInView:self.view];
    
    /*if (self.botonEditarBarButtonItem.tag == 0)
    {
        [self.tableView setEditing:YES animated:YES];
        self.botonEditarBarButtonItem.tag=1;
        self.botonEditarBarButtonItem.title=@"OK";
        self.botonEditarBarButtonItem.style=UIBarButtonItemStyleDone;
    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        self.botonEditarBarButtonItem.tag=0;
        self.botonEditarBarButtonItem.title=@"Editar";
        self.botonEditarBarButtonItem.style=UIBarButtonItemStyleBordered;
    }*/
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex: (NSInteger )buttonIndex
{
    
    NSLog(@"ButtonsIndex: %i",buttonIndex);
    
    if (buttonIndex==[actionSheet cancelButtonIndex])
    {
        NSLog(@"Cancelled");
    }
    
    if (buttonIndex == [actionSheet firstOtherButtonIndex])
    {
        NSLog(@"primer boton de otros: %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    if (buttonIndex == 0)
    {
        NSLog(@"boton 0");
    }

    
    if (buttonIndex == 1)
    {
        NSLog(@"primer boton");
    }
    if (buttonIndex ==2)
    {
        NSLog(@" segundo boton");
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - de plist

- (void) cargardePlist
{
    
    
    // self.clearsSelectionOnViewWillAppear = NO;
  
    zonasMutableArray = [[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fooPath = [documentsPath stringByAppendingPathComponent:@"zonas.plist"];
    
    NSLog(@"%@",fooPath);
    
    zonasMutableArray  = [NSMutableArray arrayWithContentsOfFile:fooPath];
    
    NSLog(@"%d Registros recuperados en zonas.plist",zonasMutableArray.count);
}


@end
