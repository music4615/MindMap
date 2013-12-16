//
//  MMMasterViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDetailViewController.h"

@class MMDetailViewController;

@interface MMMasterViewController : UITableViewController<SaveFileDelegateByMaster>
@property (strong, nonatomic) MMDetailViewController *detailViewController;

@end
