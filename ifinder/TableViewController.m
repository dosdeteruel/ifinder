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

@implementation TableViewController
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
    self.zonasMutableArray = [[NSMutableArray alloc]init];
    self.contentArray=[[NSMutableArray alloc]init];
    //self.title = @"zonas";´
    self.botonEditarBarButtonItem.enabled=NO;
    self.botonEditarBarButtonItem.title=@"Marcar";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *fooPath = [documentsPath stringByAppendingPathComponent:@"PuntosList.plist"];
    NSLog(@"%@",fooPath);
    self.zonasMutableArray  = [NSMutableArray arrayWithContentsOfFile:fooPath];
    NSLog(@"%d Registros recuperados en PuntosList.plist",self.zonasMutableArray.count);
    NSInteger *Contador = [self.zonasMutableArray count];
    if (Contador==0)
    {
        NSLog(@"El contador vale %d", Contador);
        self.zonasMutableArray  =  [ [ NSMutableArray  alloc ]  init ] ;
        for (int i=1; i<=5; i++)
        {
            [self.zonasMutableArray addObject: [ NSString  stringWithFormat: @ "Opción% i" , i ] ] ;
        }
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   // cell.textLabel.text=[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"x"];
    cell.textLabel.text=[self.zonasMutableArray objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text=[[self.zonasMutableArray objectAtIndex:indexPath.row] valueForKey:@"y"];
    //cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    
 /*   if([contentArray containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/
    cell.tag=indexPath.row;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [contentArray addObject:indexPath];
        NSLog(@"%d registros seled", self.contentArray.count);
        self.botonEditarBarButtonItem.enabled=YES;
        self.botonEditarBarButtonItem.title=@"Marcar";
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [contentArray removeObject:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}
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
    if (self.botonEditarBarButtonItem.tag == 0)
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
