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
#import "MMPickerViewController.h"

@protocol SaveFileDelegateByDetail
- (void)recieveData:(NSDictionary *)theData ;
@end


@interface MMDrawViewController : UIViewController<PopDrawDelegate, PickerDelegate>
{
    UIImageView *touching;
    UIColor *selectedColor;
    NSString *selectedShape; 
    CGPoint start ;
    NSMutableSet *touchedObjects ;
}
@property (nonatomic) NSDictionary* thisFile;

// done
@property (nonatomic) id<SaveFileDelegateByDetail> delegateInDraw;
@property (nonatomic, strong) MMPickerViewController *hiddenMenu;
@property (nonatomic, strong) UIPopoverController *hiddenMenuPopover;
@property (nonatomic, strong) MMPickerViewController *shapePickerTableView;
@property (nonatomic, strong) UIPopoverController *shapePickerPopover;
@property (nonatomic, strong) MMPickerViewController *colorPickerTableView;
@property (nonatomic, strong) UIPopoverController *colorPickerPopover;
// end of done


@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet MMGraph *mainWorkingView;


@end
