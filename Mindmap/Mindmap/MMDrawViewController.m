//
//  MMDrawViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMDrawViewController.h"

@interface MMDrawViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)choose_shape:(id)sender;
- (IBAction)choose_color:(id)sender;
- (IBAction)get_thumbnail:(id)sender;

@end

@implementation MMDrawViewController

// Mia: show the menu to choose color and shape
#pragma mark - ButtonAction
- (IBAction)choose_shape:(id)sender
{
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
- (IBAction)choose_color:(id)sender
{
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
// Mia: get the thumbnail of the screen
- (IBAction)get_thumbnail:(id)sender {

    // 1. refresh the file
    self.thisFile = [self getAFile];
    
    // 2. send it back
    [self.delegateInDraw recieveData:self.thisFile] ;

}
// Mia: end to choose the menu

// Mia: delegate from "MMPickerViewController"
#pragma mark - PickerDelegate method
-(void)selectedItem:(UIColor *)color andShape:(NSString *)shape
{
    if( color )
    {
        selectedColor = color;
        // 讓 popover 視窗 以動畫消失
        if (_colorPickerPopover) {
            [_colorPickerPopover dismissPopoverAnimated:YES];
            _colorPickerPopover = nil;
        }
        // 改變顏色
        if( [touchedObjects count] )
        {
            for (UIImageView *imgView in touchedObjects) {
                [self change_color:imgView andColor:selectedColor] ;
            } // end for loop
        }
    }
    else if( shape )
    {
        selectedShape = shape;
        if (_shapePickerPopover) {
            [_shapePickerPopover dismissPopoverAnimated:YES];
            _shapePickerPopover = nil;
        }
    }

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

// Mia: end to show the actionSheet



# pragma pop delegate
-(void) popover:(MMPopDrawViewController *) popView inputImage:(NSData *) image
{
    self.imageView.image = [UIImage imageWithData:image];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PopDraw"]) {
        MMPopDrawViewController *pop = segue.destinationViewController;
        pop.popDelegate = self;
    }
    
}

# pragma go back to master/detail
- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// Mia: 取得這的 file 的主題、所有node(nodeImageViews)、縮圖(thumbnailImageView)
- (NSDictionary*) getAFile
{
    float left, right, top, bottom;
    float counter = 0 ;
    NSMutableArray *imageSubViews = [[NSMutableArray alloc] init ] ;
    // 1. get the subViews and the edge imageViews
    for ( UIView *subview in self.view.subviews) {
        
        if( [subview isKindOfClass:[UIImageView class]] )
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
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        // crop the image of screen
    CGRect croppedImageEdge = CGRectMake(left-10, top-10, right-left+20, bottom-top+20);
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([screen CGImage], croppedImageEdge);
    UIImage *thumbnailImage = [UIImage imageWithCGImage:croppedImageRef];
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
    
    /*
    // automatic scale the photo to the size of the frame
    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    thumbnailImageView.frame = CGRectMake(0, 0, 448, 1024); // 448*1024: size of detailViewController
    */
    //3. refresh the file


    NSMutableDictionary *newFile = [[NSMutableDictionary alloc] init];
    [newFile addEntriesFromDictionary:self.thisFile];
    [newFile setObject:imageSubViews forKey:@"nodeImageViews"];
    [newFile setObject:thumbnailImageView forKey:@"thumbnailImageView"];
    [newFile setObject:@"testForThumbnail" forKey:@"title"];
    return newFile;

}


# pragma some setting
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
	// Do any additional setup after loading the view.
    [self.mainScrollView setMaximumZoomScale:3.0];
    [self.mainScrollView setMinimumZoomScale:1.0];
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollEnabled:YES];
    // initialize the graph
    
    MMNode* node = [MMNode initRootWithPoint:self.mainWorkingView.center AndDelegate:self.mainWorkingView];
    [self.mainWorkingView setRoot:node andName:@"test"];
    NSMutableArray *views = [self.thisFile objectForKey:@"nodeImageViews"] ;
    if( [views count] )
    {
        for (UIImageView *view in views) {
            [self.view addSubview:view];
        }
    }
    else
    {
    
    // Mia: init the actionSheet of shapea and color, and the touching imageView
    touching = [UIImageView alloc];
    selectedColor = [[UIColor alloc] init] ;
    touchedObjects = [[NSMutableSet alloc] init] ;
    // Mia: end to init
    
    // Mia: just for test
    CGPoint point = CGPointMake(100, 100);
    [self drawShape:@"Rectangle" andPoint:point] ;
    point = CGPointMake(400, 200);
    [self drawShape:@"Rectangle" andPoint:point] ;
    // Mia: end test
    }

}

-(void) drawShape: (NSString *)shape andPoint:(CGPoint)position
{
    if( [shape isEqualToString:@"Circle"] )
    {}
    else if( [shape isEqualToString:@"Rectangle"])
    {
        CGSize size = CGSizeMake(100.f, 100.f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *color = [[UIColor alloc] initWithRed:.5f green:.6f
                                                 blue:.7f alpha:1.f];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, (CGRect){.origin=CGPointZero, .size=size});
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *imgView = [[UIImageView alloc] initWithImage:result ];
        imgView.frame = CGRectMake(position.x, position.y, size.width, size.height);
        imgView.userInteractionEnabled = YES;
        [self.view addSubview:imgView];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
        //UITouch *touch = [[event allTouches] anyObject];
        //CGPoint location = [touch locationInView:touch.view];
    
    if( [[touch valueForKey:@"view"] isKindOfClass:[UIImageView class]] )
    {
        start = [[touches anyObject] locationInView:self.view];
        
        UIColor *borderColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        
        touching = [touch valueForKey:@"view"];
        
        [touching.layer setBorderColor:borderColor.CGColor];
        [touching.layer setBorderWidth:3.0];
        [self.view addSubview:touching];
        
        [touchedObjects addObject:touching];
    }
    else
    {
        NSLog(@"4");
    }

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    UITouch *touch = [touches anyObject];
    if( [[touch valueForKey:@"view"] isKindOfClass:[UIImageView class]] )
    {
        CGPoint location = [touch locationInView:touch.view];
        touching = [touch valueForKey:@"view"];
        CGPoint moving = CGPointMake( touching.frame.origin.x+location.x, touching.frame.origin.y+location.y);
        touching.frame = CGRectMake(moving.x, moving.y, 100.f, 100.f);
        


        touching.userInteractionEnabled = YES;
        [self.view addSubview:touching];
    }
     */
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    /*
    UITouch *touch = [touches anyObject];
    touching = [touch valueForKey:@"view"];

    [touching.layer setBorderWidth:0];
    [self.view addSubview:touching];
     */
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

@end
