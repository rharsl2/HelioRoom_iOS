//
//  OrderReasonViewController.m
//  HelioRoom
//
//  Created by admin on 1/26/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "OrderReasonViewController.h"

@interface OrderReasonViewController ()

@end

@implementation OrderReasonViewController

@synthesize reasons = _reasons;
@synthesize delegate = _delegate;

NSString * createdColor;
NSString * destinationColor;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Reason"];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(400.0, 140.0);
    //self.reasons = [NSMutableArray array];
    //[_reasons addObject:@"Red"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_reasons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *reason = [_reasons objectAtIndex:indexPath.row];
    cell.textLabel.text = reason;
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil) {
        NSString *reason = [_reasons objectAtIndex:indexPath.row];
        [_delegate reasonSelected:reason:createdColor:destinationColor];
    }
    
    
}

//HELPER FUNCTIONS
-(void) setReasons:(NSString *)created:(NSString *)destination{
    //NSString * because = @"Because";
    //NSMutableString *reason1 =
    NSString *reason1= [NSString stringWithFormat:@"%@%@%@%@", @"Because I saw ", created,@" in front of ", destination];
    NSString *reason2= [NSString stringWithFormat:@"%@%@%@%@", @"Because ", created,@" is moving faster than ", destination];
    NSString *reason3= @"Because of another reason.";
    
    self.reasons = [NSMutableArray array];
    [_reasons addObject:reason1];
    [_reasons addObject:reason2];
    [_reasons addObject:reason3];
    
    createdColor=created;
    destinationColor=destination;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}


@end
