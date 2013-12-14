//
//  MMHandDrawView.m
//  Mindmap
//
//  Created by Mac on 13/12/13.
//  Copyright (c) 2013年 NTU. All rights reserved.
//

#import "MMHandDrawView.h"

@interface MMHandDrawView () {
    UIColor* _brushColor;
}

@end

@implementation MMHandDrawView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.drawPath = [[UIBezierPath alloc] init];
        self.drawPath.lineWidth = 5;
        _brushColor = [UIColor blueColor];
        
        [self setBackgroundColor:[UIColor yellowColor]];
        
    }
    return self;
}

-(UIImage*) getImage {
    UIImage* image = nil;// UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* myTouch = [[touches allObjects] objectAtIndex:0];
    [self.drawPath moveToPoint:[myTouch locationInView:self]];
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* myTouch = [[touches allObjects] objectAtIndex:0];
    [self.drawPath addLineToPoint:[myTouch locationInView:self]];
    
    [self setNeedsDisplay];
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [_brushColor setStroke];
    [self.drawPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    //[self.drawPath stroke];
}


@end
