//
//  MMDetailViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawViewController.h"

@protocol SaveFileDelegateByMaster
- (void)storeData:(NSDictionary *)theData ;
@end



@interface MMDetailViewController : UIViewController <UISplitViewControllerDelegate, SaveFileDelegateByDetail>
@property (strong, nonatomic) id<SaveFileDelegateByMaster> delegateInDetail;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
