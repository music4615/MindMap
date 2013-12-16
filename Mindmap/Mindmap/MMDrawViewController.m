//
//  MMDrawViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMDrawViewController.h"

@interface MMDrawViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *colorButton;

@end

@implementation MMDrawViewController
@synthesize thisFile;



# pragma pop delegate
-(void) popover:(MMPopDrawViewController *) popView inputImage:(UIImage*) image
{
    UIImageView* imView = [[UIImageView alloc] initWithImage:image];
    [imView setFrame:CGRectMake(0, 0, 100, 100)] ;
    [self.mainWorkingView.selectedNode addSubview:imView];
    [self.drawPopoverController dismissPopoverAnimated:YES];
    self.drawPopoverController = nil;
}

-(BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    
    return YES;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.drawPopoverController = nil;
    self.wePopoverController = nil;
}

- (IBAction)popoverButtonTouched:(id)sender {
    if (self.drawPopoverController) {
        // dismiss popover
        [self.drawPopoverController dismissPopoverAnimated:YES];
        self.drawPopoverController = nil;
    }
    else {
        if (self.mainWorkingView.selectedNode) {
            [self performSegueWithIdentifier:@"PopDraw" sender:self];
        }
        
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PopDraw"]) {
        MMPopDrawViewController *pop = segue.destinationViewController;
        pop.popDelegate = self;
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            self.drawPopoverController = [(UIStoryboardPopoverSegue*)segue popoverController];
            [self.drawPopoverController setDelegate:self];
        }
    }
    
}


#pragma mark - PickerDelegate method
-(void)selectedItem:(NSString *)shape
{
    if( shape && self.mainWorkingView.selectedNode )
    {

        [self.mainWorkingView.selectedNode.layer setBorderWidth:0.0];

        for (UIView* temp in [self.mainWorkingView.selectedNode subviews]) {
            [temp removeFromSuperview];
        }
        MMNode *select = self.mainWorkingView.selectedNode;
        [select addSubview:[select drawShape:shape]];
    
        if (_shapePickerPopover) {
            [_shapePickerPopover dismissPopoverAnimated:YES];
            _shapePickerPopover = nil;
        }
    }
}

- (IBAction)save:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        // 1. refresh the file
        self.thisFile = [self getAFile];
        // 2. send it back adn store it
        [self.delegateInDraw recieveData:self.thisFile] ;
    });
}
- (NSDictionary*) getAFile
{
    float left, right, top, bottom;
    float counter = 0 ;
    NSMutableArray *imageSubViews = [[NSMutableArray alloc] init ] ;
    // 1. get the subViews and the edge imageViews
    for ( UIView *subview in self.mainWorkingView.subviews) {
        
        
        if( [subview isKindOfClass:[MMNode class]] )
        {
            [imageSubViews addObject:subview] ;
            if( counter == 0 )
            {
                left = subview.frame.origin.x;
                right = subview.frame.origin.x + subview.frame.size.width;
                top = subview.frame.origin.y;
                bottom = subview.frame.origin.y + subview.frame.size.height;
                counter++;
                continue;
            }
            
            if( subview.frame.origin.x < left )
            {   left = subview.frame.origin.x;  }
            if( subview.frame.origin.x + subview.frame.size.width > right )
            {   right = subview.frame.origin.x + subview.frame.size.width;  }
            if( subview.frame.origin.y < top )
            {   top = subview.frame.origin.y;   }
            if( subview.frame.origin.y + subview.frame.size.height > bottom )
            {   bottom = subview.frame.origin.y + subview.frame.size.height;    }
        }
    }
    
    // 2. get the thumbnail
    //the action of printing screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // crop the image of screen
    CGRect croppedImageEdge = CGRectMake(left-10, top-10, right-left+20, bottom-top+20);
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([screen CGImage], croppedImageEdge);
    UIImage *thumbnailImage = [UIImage imageWithCGImage:croppedImageRef];
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit ;
    
    NSMutableDictionary *newFile = [[NSMutableDictionary alloc] init];
    
    [newFile addEntriesFromDictionary:self.thisFile];
    [newFile setObject:imageSubViews forKey:@"nodeImageViews"];
    [newFile setObject:thumbnailImageView forKey:@"thumbnailImageView"];
    [newFile setObject:@"testForThumbnail" forKey:@"title"];
    return newFile;
    
}

- (IBAction)changeShape:(id)sender {
    if (_shapePickerTableView == nil) {
        //Create the ColorPickerViewController.
        _shapePickerTableView = [[MMPickerViewController alloc] init];
        _shapePickerTableView.type = @"Shape";
        _shapePickerTableView = [_shapePickerTableView initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _shapePickerTableView.delegate = self;
    }
    
    if (_shapePickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _shapePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_shapePickerTableView];
        [_shapePickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else {
        //The color picker popover is showing. Hide it.
        [_shapePickerPopover dismissPopoverAnimated:YES];
        _shapePickerPopover = nil;
    }
}
- (UIView *)viewForBarItem:(UIBarButtonItem *)item inToolbar:(UIToolbar *)toolbar
{
    // NOTE: This relies on internal implementation
    // TODO: Better implementation for iOS5+
    
    // Sort toolbar subviews to match order of toolbar items
    NSArray *subviews = [toolbar.subviews sortedArrayUsingComparator:^NSComparisonResult(id view1, id view2) {
        return [view1 frame].origin.x - [view2 frame].origin.x;
    }];
    
    // NOTE: Not sure why but had to filter out UIImageView from toolbar subviews
    NSMutableArray *mutableSubviews = [[NSMutableArray alloc] init];
    for(UIView *subview in subviews) {
        if(![subview isKindOfClass:[UIImageView class]]) {
            [mutableSubviews addObject:subview];
        }
    }
    
    int itemIndex = [toolbar.items indexOfObject:item];
    int adjustedIndex = itemIndex;
    for(int i=0; i<itemIndex; i++) {
        UIBarButtonItem *anItem = [toolbar.items objectAtIndex:i];
        if(anItem.tag == -1) adjustedIndex--;
    }
    
    UIView *buttonView = [mutableSubviews objectAtIndex:adjustedIndex];

    return buttonView;
}

- (CGRect)rectForBarItem:(UIBarButtonItem *)item inToolbar:(UIToolbar *)toolbar
{
    UIView *buttonView = [self viewForBarItem:item inToolbar:toolbar];
    CGRect rect = [buttonView convertRect:buttonView.bounds toView:self.view];
    
    return rect;
}

- (IBAction)changeColor:(id)sender {

    if (!self.wePopoverController) {

        ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
        self.wePopoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.wePopoverController.delegate = self;
        [self.wePopoverController presentPopoverFromRect:CGRectMake(130, 0, 0,0)
                                                  inView:self.mainWorkingView
                                permittedArrowDirections:UIPopoverArrowDirectionUp
                                                animated:YES];

        [[[self.wePopoverController contentViewController] view] setBackgroundColor:[UIColor blackColor]];
        
    }
    else
    {
        [self.wePopoverController dismissPopoverAnimated:YES];
        self.wePopoverController = nil;
    }
}

-(void) colorPopoverControllerDidSelectColor:(NSString *)hexColor{
    [self change_color:self.mainWorkingView.selectedNode andColor:[GzColors colorFromHex:hexColor]];

    [self.view setNeedsDisplay];
    [self.wePopoverController dismissPopoverAnimated:YES];
    self.wePopoverController = nil;
     
}
- (void) change_color:(MMNode *)imgView andColor:(UIColor *)color
{
    self.mainWorkingView.selectedNode.selectedColor = color;
    // 重新畫出一張圖，然後 把它的顏色 Blend
    UIGraphicsBeginImageContext(imgView.frame.size);
    
    [[imgView layer] renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    [color setFill];
    
    CGContextTranslateCTM(context, 0, imgView.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGRect rect = CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height);

    CGContextDrawImage(context, rect, image.CGImage);
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    UIImage *blendResult = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *nodeImageView = [[UIImageView alloc] initWithImage:blendResult];

    [imgView addSubview:nodeImageView];
}



# pragma go back to master/detail
- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


# pragma some setting
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.drawPopoverController = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.mainScrollView setMaximumZoomScale:3.0];
    [self.mainScrollView setMinimumZoomScale:1.0];
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollEnabled:YES];
    
    // initialize the graph
    if( [[self.thisFile objectForKey:@"nodeImageViews"] count])
    {
        NSMutableArray *temp = [self.thisFile objectForKey:@"nodeImageViews"];
        [self.mainWorkingView drawFromNodes:temp];
    }
    else
    {
        MMNode* node = [MMNode initRootWithPoint:self.mainWorkingView.center AndDelegate:self.mainWorkingView];
        [self.mainWorkingView setRoot:node andName:@"test"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight);
}

#pragma scrollDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  {
    return self.mainWorkingView;
}

# pragma basic operation
- (IBAction)deleteSelectedNode:(id)sender {
    if (self.mainWorkingView.selectedNode != self.mainWorkingView.root) {
        [self.mainWorkingView.selectedNode deleteNode];
        self.mainWorkingView.selectedNode = nil;
    }
}

#pragma mark Color Picker

#pragma mark WEPopoverControllerDelegate implementation





@end
