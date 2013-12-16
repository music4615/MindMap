//
//  MMDrawViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMDrawViewController.h"

@interface MMDrawViewController ()

@end

@implementation MMDrawViewController

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
    
    NSLog(@"should");
    [self.drawPopoverController dismissPopoverAnimated:YES];
    self.drawPopoverController = nil;
    return YES;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.drawPopoverController = nil;
    NSLog(@"did");
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
            pop.popController = self.drawPopoverController;
        }
    }
    
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

- (void) change_color:(UIImageView *)imgView andColor:(UIColor *)color
{
    // 重新畫出一張圖，然後 把它的顏色 Blend
    UIGraphicsBeginImageContext(imgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color setFill];
    
    CGContextTranslateCTM(context, 0, imgView.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGRect rect = CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height);
    CGContextDrawImage(context, rect, imgView.image.CGImage);
    
    CGContextClipToMask(context, rect, imgView.image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imgView setImage:temp] ;
}
#pragma mark - PickerDelegate method
-(void)selectedItem:(UIColor *)color andShape:(NSString *)shape
{
    if( color )
    {
        self.mainWorkingView.selectedNode.selectedColor = color;
        // 讓 popover 視窗 以動畫消失
        if (_colorPickerPopover) {
            [_colorPickerPopover dismissPopoverAnimated:YES];
            _colorPickerPopover = nil;
        }
        // 改變顏色
        if( self.mainWorkingView.selectedNode )
        {
            UIImageView *imgView = [self.mainWorkingView.selectedNode.subviews objectAtIndex:0];
            [imgView setFrame:CGRectMake(0, 0, 100, 100)];
            [self change_color:imgView andColor:color] ;
            //[self.mainWorkingView.selectedNode setTransform:CGAffineTransformIdentity];
            
        }
    }
    /*
    else if( shape )
    {
        selectedShape = shape;
        if (_shapePickerPopover) {
            [_shapePickerPopover dismissPopoverAnimated:YES];
            _shapePickerPopover = nil;
        }
    }
     */
    
}
- (IBAction)save:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        // 1. refresh the file
        self.thisFile = [self getAFile];
        // 2. send it back
        [self.delegateInDraw recieveData:self.thisFile] ;
        
    });
}


- (IBAction)changeColor:(id)sender {
    if (_colorPickerTableView == nil) {
        //Create the ColorPickerViewController.
        _colorPickerTableView = [[MMPickerViewController alloc] init];
        _colorPickerTableView.type = @"Color";
        _colorPickerTableView = [_colorPickerTableView initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _colorPickerTableView.delegate = self;
    }
    
    if (_colorPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _colorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_colorPickerTableView];
        [_colorPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else {
        //The color picker popover is showing. Hide it.
        [_colorPickerPopover dismissPopoverAnimated:YES];
        _colorPickerPopover = nil;
        //self.view.userInteractionEnabled = YES ;
    }

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
    
    MMNode* node = [MMNode initRootWithPoint:self.mainWorkingView.center AndDelegate:self.mainWorkingView];
    [self.mainWorkingView setRoot:node andName:@"test"];
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


@end
