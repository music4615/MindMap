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
    [imView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
    [self.mainWorkingView.selectedNode addSubview:imView];
    [self.drawPopoverController dismissPopoverAnimated:YES];
    self.drawPopoverController = nil;
}

-(BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    
    return YES;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.drawPopoverController = nil;
}

- (IBAction)popoverButtonTouched:(id)sender {
    NSLog(@"touched%@", self.drawPopoverController);
    if (self.drawPopoverController) {
        // dismiss popover
        [self.drawPopoverController dismissPopoverAnimated:YES];
        self.drawPopoverController = nil;
        NSLog(@"pop");
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
            NSLog(@"seque");
            [self.drawPopoverController setDelegate:self];
        }
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
