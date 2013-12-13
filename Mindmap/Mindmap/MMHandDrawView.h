//
//  MMHandDrawView.h
//  Mindmap
//
//  Created by Mac on 13/12/13.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHandDrawView : UIView

@property UIBezierPath* drawPath;

-(UIImage*) getImage;

@end
