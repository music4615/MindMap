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
@end

@implementation MMDrawViewController

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
    [self.mainScrollView setMaximumZoomScale:5.0];
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


@end
