//
//  MMPopDrawViewController.h
//  Mindmap
//
//  Created by 陳 昭廷 on 2013/11/23.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopDrawDelegate ;
@interface MMPopDrawViewController : UIViewController

@property (weak) id<PopDrawDelegate> popDelegate ;
@end

@protocol PopDrawDelegate <NSObject>

-(void) popover:(MMPopDrawViewController *) popView inputImage:(NSData *) image ;

@end
