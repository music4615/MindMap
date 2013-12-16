//
//  MMDrawViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "WEPopoverController.h"
#import "ColorViewController.h"
#import "GzColors.h"

#import "MMPopDrawViewController.h"
#import "MMPickerViewController.h"
#import "MMCore.h"

@protocol SaveFileDelegateByDetail
- (void)recieveData:(NSDictionary *)theData ;
@end


@interface MMDrawViewController : UIViewController<PopDrawDelegate,UIPopoverControllerDelegate, UIScrollViewDelegate, PickerDelegate, WEPopoverControllerDelegate, ColorViewControllerDelegate>

@property (nonatomic, strong) WEPopoverController *wePopoverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *colorPicker;

@property (nonatomic) NSDictionary* thisFile;
@property (nonatomic) id<SaveFileDelegateByDetail> delegateInDraw;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet MMGraph *mainWorkingView;
@property (strong, nonatomic) UIPopoverController* drawPopoverController;


@property (nonatomic, strong) MMPickerViewController *hiddenMenu;
@property (nonatomic, strong) UIPopoverController *hiddenMenuPopover;
@property (nonatomic, strong) MMPickerViewController *shapePickerTableView;
@property (nonatomic, strong) UIPopoverController *shapePickerPopover;


@end
