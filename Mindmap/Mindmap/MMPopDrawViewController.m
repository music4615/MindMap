//
//  MMPopDrawViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMPopDrawViewController.h"

@interface MMPopDrawViewController ()

@end

@implementation MMPopDrawViewController

- (IBAction)doneButtonClicked:(id)sender {
    //make current context a image
    UIImage* image = [self.drawView getImage];
    
    if([self.popDelegate respondsToSelector:@selector(popover:inputImage:)])
    {
        [self.popDelegate popover:self inputImage:image] ;
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.popController.delegate popoverControllerShouldDismissPopover:self.popController];
    NSLog(@"cancel");
}

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
    [self.drawView.layer setCornerRadius:32];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
