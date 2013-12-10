//
//  MMDetailViewController.m
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMDetailViewController.h"

@interface MMDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UIButton *thumbnailImageView;
- (void)configureView;
@end

@implementation MMDetailViewController


// Mia: 設定呈現的縮圖
- (void) setThumbnailImageView
{
    UIImageView *temp = [self.itemDic objectForKey:@"thumbnailImageView"] ;
    [self.thumbnailImageView.imageView setImage:temp.image] ;
}
- (void)recieveData:(NSDictionary *)theData {
    
    //Do something with data here

    [self.delegateInDetail storeData:theData] ;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(UIImageView*) newDetailItem
{
    
/*
    self.detailItem = newDetailItem;
    NSLog(@"%d", [self.detailItem count]);
    
    UIImageView *temp = newDetailItem;
    [self.thumbnailImageView.imageView setImage:temp.image];
    self.thumbnailImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;


    
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }    
    */
}

- (void)configureView
{
    if (self.itemDic) {
        UIImageView *temp = [self.itemDic objectForKey:@"thumbnailImageView"];
        if( temp )
        {NSLog(@"should be hereee");}
        [self.thumbnailImageView.imageView setImage:temp.image];
        self.thumbnailImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    // Update the user interface for the detail item.
    /*
    if (detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDrawViewController"]) {
        MMDrawViewController *draw = [segue destinationViewController];
        draw.delegateInDraw = self;
        draw.thisFile = self.itemDic ;
        
    }
}



@end
