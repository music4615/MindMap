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
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderColor:[UIColor yellowColor].CGColor];
        [self.layer setBorderWidth:3.0]; 
    }
    return self;
}

-(UIImage*) getImage {
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // crop the image of screen
//    CGRect croppedImageEdge = CGRectMake(0, 0, 480, 640);
//    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([screen CGImage], croppedImageEdge);
//    UIImage *thumbnailImage = [UIImage imageWithCGImage:croppedImageRef];
//    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
//    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit ;

    
    
    return screen;
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
