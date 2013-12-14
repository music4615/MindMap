//
//  MMDrawViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPopDrawViewController.h"
#import "MMCore.h"

@interface MMDrawViewController : UIViewController<PopDrawDelegate,UIPopoverControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet MMGraph *mainWorkingView;
@property (strong, nonatomic) UIPopoverController* drawPopoverController;

-(IBAction)popoverButtonTouched:(id)sender;

@end
