//
//  MMPopDrawViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHandDrawView.h"

@protocol PopDrawDelegate ;

@interface MMPopDrawViewController : UIViewController

@property (weak) id<PopDrawDelegate> popDelegate ;
@property (strong, nonatomic) IBOutlet MMHandDrawView *drawView;


@end

@protocol PopDrawDelegate <NSObject>

-(void) popover:(MMPopDrawViewController *) popView inputImage:(UIImage *) image ;

@end
