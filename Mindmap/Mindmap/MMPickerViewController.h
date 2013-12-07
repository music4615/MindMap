//
//  MMPickerViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/12/5.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerDelegate <NSObject>
@required
-(void)selectedItem:(UIColor *)color andShape:(NSString *)color;


@end

@interface MMPickerViewController : UITableViewController

@property (nonatomic, weak) NSString *type; 
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) id<PickerDelegate> delegate;
@end