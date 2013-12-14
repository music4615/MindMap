//
//  MMPickerViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/12/5.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMPickerViewController.h"

@interface MMPickerViewController ()

@end

@implementation MMPickerViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        _items = [NSMutableArray array];
        if( [self.type  isEqualToString:@"Shape"] )
        {
            [_items addObject:@"Circle"];
            [_items addObject:@"Rectangle"];
        }
        else if( [self.type isEqualToString:@"Color"] )
        {
            [_items addObject:@"Red"];
            [_items addObject:@"Green"];
            [_items addObject:@"Blue"];
        }
        else if( [self.type isEqualToString:@"Hidden"] )
        {
            [_items addObject:@"Add"];
            [_items addObject:@"Delete"];
            [_items addObject:@"Color"];
            [_items addObject:@"Shape"];
        }
        
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;
        
        // 固定每個 row 的大小
        NSInteger rowsCount = [_items count];

        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how
        //wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *single in _items) {
            //Checks size of text using the default font for UITableViewCell's textLabel.
            CGSize labelSize = [single sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        
        //Set the property to tell the popover container how big this view will be.
        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /*
    // config the cell
    UIFont *itemFont = [ UIFont fontWithName:@"Arial" size: .0];
    cell.textLabel.font  = itemFont;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"test.jpg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"test.jpg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
     */

    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [_items objectAtIndex:indexPath.row];
    
    if( [self.type isEqualToString:@"Color"] )
    {
        // default color
        UIColor *color = [UIColor orangeColor];
        
        //Set the color object based on the selected color name.
        if ([selected isEqualToString:@"Red"]) {
            color = [UIColor redColor];
        }
        else if ([selected isEqualToString:@"Green"]){
            color = [UIColor greenColor];
        }
        else if ([selected isEqualToString:@"Blue"]) {
            color = [UIColor blueColor];
        }
        //Notify the delegate if it exists.
        if (_delegate != nil) {
            [_delegate selectedItem:color andShape:nil];
        }
    }
    else if( [self.type isEqualToString:@"Shape"] )
    {
        // default color
        NSString *shape = @"Circle";
        
        //Set the color object based on the selected color name.
        if ([selected isEqualToString:@"Circle"]) {
            //shape = [UIColor redColor];
        }
        else if ([selected isEqualToString:@"Rectangle"]){
            
        }

        //Notify the delegate if it exists.
        if (_delegate != nil) {
            [_delegate selectedItem:nil andShape:shape];
        }
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
