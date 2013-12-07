//
//  MMMasterViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMMasterViewController.h"



@interface MMMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *files;
}
@end

@implementation MMMasterViewController
//Mia: get the data from detailViewController
- (void)storeData:(NSDictionary *)theData
{
    if( !files)
    {
        files = [[NSMutableArray alloc] init] ;
    }
    [files insertObject:theData atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
 //   [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    NSLog(@"gg %d", [files count]);
    
}
- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (MMDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Miaaa
    [addButton.target performSelector:addButton.action];
    if( !files)
    {
        files = [[NSMutableArray alloc] init];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    UIImage *im = [[UIImage alloc] initWithContentsOfFile:filePath];
    UIImageView *img = [[UIImageView alloc] initWithImage:im];
    NSDictionary *t = [[NSDictionary alloc] initWithObjectsAndKeys:img, @"imageView", nil];
    [files insertObject:t atIndex:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
     if (!_objects) {
         _objects = [[NSMutableArray alloc] init];
     }
     [_objects insertObject:[NSDate date] atIndex:0];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Miaaa
        UIImageView *tmp = [files[indexPath.row] objectForKey:@"imageView"];
        [self.detailViewController setDetailItem:tmp ];
        self.detailViewController.delegateInDetail = self ;
        /*
         NSDate *object = _objects[indexPath.row];
         self.detailViewController.detailItem = object;
         
         */
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        MMDetailViewController *detail = [segue destinationViewController];
        [detail setDetailItem:object];
        
    }
}

@end




