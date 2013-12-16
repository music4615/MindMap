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
    [_objects replaceObjectAtIndex:0 withObject:theData];
    

    /*
    if( !_objects)
    {
        _objects = [[NSMutableArray alloc] init] ;
    }

    [_objects insertObject:theData atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
*/

    
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
    
    // init the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newAndGotoMain:)];
    self.navigationItem.rightBarButtonItem = addButton;
    // init MMDetailViewCOntroller
    self.detailViewController = (MMDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    
    // Miaaa
// [addButton.target performSelector:addButton.action];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Mia: 按下add button後 ...
- (void)newAndGotoMain:(id)sender
{
    // 1. insert a default dictionary into _objects
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    UIImage *defaultThumbnail = [[UIImage alloc] initWithContentsOfFile:filePath];
    UIImageView *img = [[UIImageView alloc] initWithImage:defaultThumbnail];
    img.contentMode = UIViewContentModeScaleAspectFit;

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:img, @"thumbnailImageView",
                                                                    @"defaultFileName", @"title", nil];
    [_objects insertObject:dic atIndex:0];
    
    
    // 2. insert and show in columns
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 3. set delegate to pass the data from mainEditor, and pass the data
    self.detailViewController.delegateInDetail = self ;
    self.detailViewController.itemDic = [_objects objectAtIndex:0];
    
    // 4. enter the mainEditor
    [self.detailViewController performSegueWithIdentifier: @"ShowDrawViewController" sender: self];


}
/*
//Mia: 改成 -- 當要離開mainEditor時，再insert
- (void)insertNewObject
{
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"nodeImg" ofType:@"png"];
    UIImage *im = [[UIImage alloc] initWithContentsOfFile:filePath];
    UIImageView *img = [[UIImageView alloc] initWithImage:im];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:img, @"imageView", nil];
    [_objects insertObject:dic atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.detailViewController setDetailItem:img ];
    self.detailViewController.delegateInDetail = self ;
 
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *title = [_objects[indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = title;
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
- (NSInteger) getNewFileID
{
    NSInteger biggestID;
    if( [_objects count])
    {
        biggestID = (NSInteger)[[_objects objectAtIndex:0] objectForKey:@"fileID"];
        biggestID ++ ;
    }
    else
    {
        biggestID = 0 ;
    }
    return biggestID;
    
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
        //UIImageView *tmp = [_objects[indexPath.row] objectForKey:@"thumbnailImageView"];
        
        self.detailViewController.itemDic = _objects[indexPath.row];

        [self.detailViewController setThumbnailImageView];

        self.detailViewController.delegateInDetail = self ;
        /*
         NSDate *object = _objects[indexPath.row];
         self.detailViewController.detailItem = object;
         
         */
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

/*
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = _objects[indexPath.row];
        MMDetailViewController *detail = [segue destinationViewController];
        detail.itemDic = object ;
//        [detail setDetailItem:object];
    }
 */
     
}

@end




