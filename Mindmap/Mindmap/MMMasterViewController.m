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
    NSMutableArray *_files;
}
@end

@implementation MMMasterViewController

// update
- (void)storeData:(NSDictionary *)theData
{
    NSLog(@"before");
    [self storeToDisk:theData andisNew:NO] ;

    
    [self.tableView reloadData];
    /*
    NSLog(@"%d", [[theData objectForKey:@"nodeImageViews"] count] );
    [_objects replaceObjectAtIndex:0 withObject:theData];
    
    [self.tableView reloadData];
    
    // store to disk
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"saveDatatest.test"];
    [NSKeyedArchiver archiveRootObject:theData toFile:filename];
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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newAndGotoMain:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (MMDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    // read files from disk!
    [self getFilePaths];

    [self.tableView setSeparatorColor:[self colorWithHexString:@"34AADC"]] ;

}
- (void)newAndGotoMain:(id)sender
{
    // 1. insert a default dictionary into _objects
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    UIImage *defaultThumbnail = [[UIImage alloc] initWithContentsOfFile:imgPath];
    UIImageView *img = [[UIImageView alloc] initWithImage:defaultThumbnail];
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:img, @"thumbnailImageView",
                         @"defaultFileName", @"title",
                         [NSDate date], @"fileName", nil];
    
    [self storeToDisk:dic andisNew:YES];

    /*
    // 2. insert and show in columns
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    */
    // 3. set delegate to pass the data from mainEditor, and pass the data
    self.detailViewController.delegateInDetail = self ;
    self.detailViewController.itemDic = dic;
    
    // 4. enter the mainEditor
    [self.detailViewController performSegueWithIdentifier: @"ShowDrawViewController" sender: self];
    
    [self.tableView reloadData];
    
}

-(void) storeToDisk:(NSDictionary *)theData andisNew:(BOOL)isNew
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Mindmaps"];
    // 1. mkdir
    if( isNew )
    {
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {   NSLog(@"Create directory error: %@", error);    }
        }
        
        // 2. store
        
        NSString *fileName = [NSString stringWithFormat:@"%@", [theData objectForKey:@"fileName"]];
        path = [path stringByAppendingPathComponent:fileName];
        [NSKeyedArchiver archiveRootObject:theData toFile:path];
        
        // for temp usage
        [_objects insertObject:path atIndex:0];

        [_files insertObject:theData atIndex:0];
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:@"%@", [theData objectForKey:@"fileName"]];
        path = [path stringByAppendingPathComponent:fileName];
        [NSKeyedArchiver archiveRootObject:theData toFile:path];
        
        [_files replaceObjectAtIndex:0 withObject:theData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"item-icon-file.png"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"file-cell-short.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"file-cell-short.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

    
    [cell setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
//    cell.contentView.backgroundColor = [self colorWithHexString:@"AADFFF"];   // 1929FF

    NSDictionary *file = [self getFileContent:_objects[indexPath.row]];
    NSString *title = [file objectForKey:@"title"];

    cell.textLabel.text = title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"path in didselect %@", _objects[indexPath.row]);
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"item-icon-file-selected.png"];
        [cell setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        cell.textLabel.textColor = [UIColor blackColor];
        
        self.detailViewController.itemDic = [self getFileContent:_objects[indexPath.row]];
        [self.detailViewController setThumbnailImageView];
        self.detailViewController.delegateInDetail = self ;
    }
}


- (NSDictionary *) getFileContent: (NSString *)path
{
    NSDictionary *fileContent = [[NSDictionary alloc] init];
    fileContent = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
    return fileContent;
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

// bonus
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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


- (void) getFilePaths
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Mindmaps"];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (int Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        NSString *eachFilePath = [path stringByAppendingPathComponent:[directoryContent objectAtIndex:Count]];
        [_objects insertObject:eachFilePath atIndex:0];
    }
    
    /*
    
    
    
    [_objects insertObject:[self getFileFromDisk] atIndex:0];
    
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Mindmaps"];

	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
    }

    
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"saveDatatest.test"];
    NSDictionary *getFile = [[NSDictionary alloc] init];
    getFile = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    return getFile;
     */
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
     */
}



@end
