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
<<<<<<< HEAD
#import "MMPickerViewController.h"

@interface MMDrawViewController : UIViewController<PopDrawDelegate, PickerDelegate>
{
    UIImageView *touching;
    UIColor *selectedColor;
    NSString *selectedShape; 
    CGPoint start ;
    NSMutableSet *touchedObjects ;
}

@property (nonatomic, strong) MMPickerViewController *shapePickerTableView;
@property (nonatomic, strong) UIPopoverController *shapePickerPopover;
@property (nonatomic, strong) MMPickerViewController *colorPickerTableView;
@property (nonatomic, strong) UIPopoverController *colorPickerPopover;


=======

@interface MMDrawViewController : UIViewController<PopDrawDelegate, UIScrollViewDelegate>
>>>>>>> 7bd3cefd30d6476047d5bf8ff568a7996db369e9

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet MMGraph *mainWorkingView;


@end
