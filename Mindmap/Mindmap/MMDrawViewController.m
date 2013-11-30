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
-(void) popover:(MMPopDrawViewController *) popView inputImage:(NSData *) image
{
    self.imageView.image = [UIImage imageWithData:image];
}

- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMPopDrawViewController *pop = segue.destinationViewController;
    pop.popDelegate = self;
}

@end
