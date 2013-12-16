//
//  MMCore.m
//  MindMap
//
//  Created by Mac on 13/11/28.
//  Copyright (c) 2013年 NTUEE. All rights reserved.
//

#import "MMCore.h"
#import "GzColors.h"


// NODE
@interface MMNode () {
    
}


@end

@implementation MMNode

+(instancetype) initRootWithPoint:(CGPoint)point AndDelegate:(id)delegate {
    MMNode* node = [[MMNode alloc] init];
    node.parent = nil;
    node.children = [NSMutableArray array];
    node.childEdges = [NSMutableDictionary dictionary];
    node.drawNodeDelegate = delegate;
    node.selectedShape = @"Rounded Rectangle";
    
    UIColor *color = [GzColors colorFromHex:@"0xFFFFB6AB"];


    node.selectedColor = color;
    
    CGSize imageSize = CGSizeMake(100.f, 50.f);
    [node setFrame:CGRectMake(point.x-imageSize.width/2.0, point.y-imageSize.height/2.0, imageSize.width, imageSize.height)];
    
    UIImageView *nodeImageView = [node drawShape:node.selectedShape];
    [node addSubview:nodeImageView];
    [node setGestures];

    return node;
}

+(instancetype) initWithParent:(MMNode *)parent andPoint:(CGPoint)point{
    MMNode* node = [[MMNode alloc] init];
    node.parent = parent;
    node.children = [NSMutableArray array];
    node.childEdges = [NSMutableDictionary dictionary];
    node.drawNodeDelegate = parent.drawNodeDelegate;
    node.selectedColor = parent.selectedColor;
    node.selectedShape = parent.selectedShape;

    CGSize imageSize = CGSizeMake(100.f, 50.f);
    [node setFrame:CGRectMake(point.x-imageSize.width/2.0, point.y-imageSize.height/2.0, imageSize.width, imageSize.height)];
    UIImageView *nodeImageView = [node drawShape:node.selectedShape];
    // set node images

    
    
    [node addSubview:nodeImageView];
    
    [node setGestures];
    
    return node;
}

-(UIImageView *) drawShape:(NSString *)shape
{
    self.selectedShape = shape;
    CGRect fillSize = CGRectMake(self.bounds.origin.x+3, self.bounds.origin.y+3, self.bounds.size.width-6, self.bounds.size.height-6);
    
    const CGFloat* colorComponents = CGColorGetComponents(self.selectedColor.CGColor);
    float most = 0 ;
    int pos = 0 ;
    for(int i=0; i<3; i++)
    {
        if( i == 0 )
        {
            most = colorComponents[0];
            pos = i ;
            continue;
        }
        if( colorComponents[i] > most )
        {
            most = colorComponents[i];
            pos = i ;
        }
    }
    UIColor *strokeColor = [GzColors strokeColor:@"0xFFFFB6AB"];
    /*
    if( pos == 0 )
    {
        strokeColor = [GzColors colorFromHex:@"0xFFA34C27"];
    }
    else if( pos == 1 )
    {
        strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
//        strokeColor = [UIColor colorWithRed:0.2 green:1 blue:0.4 alpha:1];
    }
    else if( pos == 2 )
    {
        strokeColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1];
    }
    
    */
    
    if( [shape isEqualToString:@"Circle"] )
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [strokeColor setFill];
        CGContextFillEllipseInRect(context, self.bounds);
        [self.selectedColor setFill];
        CGContextFillEllipseInRect(context, fillSize);

    }
    else if( [shape isEqualToString:@"Rectangle"])
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [strokeColor setFill];
        CGContextFillRect(context, self.bounds);
        [self.selectedColor setFill];
        CGContextFillRect(context, fillSize);

    }
    else if( [shape isEqualToString:@"Rounded Rectangle"] )
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0f);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:13.f];
        [strokeColor setFill];
        [path fill];
        path = [UIBezierPath bezierPathWithRoundedRect:fillSize cornerRadius:13.f];
        [self.selectedColor setFill];
        [path fill];
    }

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *nodeImageView = [[UIImageView alloc] initWithImage:result];
    
    nodeImageView.userInteractionEnabled = YES;
    return nodeImageView;
}


-(void) setGestures {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGuesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer* singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSinglePan:)];
    singlePan.minimumNumberOfTouches = singlePan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:singlePan];
    
    if (self.parent) {// root doesn't move
        UIPanGestureRecognizer* doublePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToDoublePan:)];
        doublePan.minimumNumberOfTouches = doublePan.maximumNumberOfTouches = 2;
        [self addGestureRecognizer:doublePan];
        
        [doublePan requireGestureRecognizerToFail:tapRecognizer];
        [singlePan requireGestureRecognizerToFail:tapRecognizer];
    }
    
    //set order between guestures
    [singlePan requireGestureRecognizerToFail:tapRecognizer];
}

-(MMNode*) addChildAtPoint:(CGPoint)point {
    MMNode* child = [MMNode initWithParent:self andPoint:point];
    UIView* edge = nil;
    edge = [self changeEdge:edge FromPoint:self.center toPoint:point];
    [self.childEdges setObject:edge forKey:@((size_t)(child))];
    [self.children addObject:child];
    
    return child;
}

-(UIView*) changeEdge:(UIView*)edge FromPoint:(CGPoint)pA toPoint:(CGPoint)pB {
    
    double distance = sqrt(pow(pA.x - pB.x, 2.0) + pow(pA.y - pB.y, 2.0));
    double angle = atan2(pA.y - pB.y, pA.x - pB.x);
    CGPoint center = CGPointMake((pA.x+pB.x)/2.0, (pA.y+pB.y)/2.0);
    if (edge) {
        [edge setTransform:CGAffineTransformIdentity];
        [edge setFrame:CGRectMake(center.x-distance/2.0, center.y-1, distance, 2)];
        [edge setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }
    else {
        edge = [[UIView alloc] initWithFrame:CGRectMake(center.x-distance/2.0, center.y-1, distance, 2)];
        [edge setTransform:CGAffineTransformRotate(edge.transform, angle)];
    }
    edge.backgroundColor = [UIColor redColor];

    return edge;
    
}

-(void) deleteNode {
    // add children's ptrs to parent
    [self.parent.children addObjectsFromArray:(NSArray*)self.children];
    // add parent ptr & edge to children
    for (MMNode* child in self.children) {
        child.parent = self.parent;
        UIView* edge = self.childEdges[@((size_t)child)];
        [self changeEdge:edge FromPoint:child.center toPoint:self.parent.center];
        [self.parent.childEdges setObject:edge forKey:@((size_t)child)];
        //[self.children removeObjectIdenticalTo:child];
    }
    
    // remove parent edge to self
    [self.parent.childEdges[@((size_t)self)] removeFromSuperview];
    //remove self view
    [self removeFromSuperview];
    // remove parent's ptr to self
    [self.parent.children removeObjectIdenticalTo:self];
    
}

#pragma responds to guestures

-(IBAction)respondToTapGuesture:(UITapGestureRecognizer*)recognizer {
    [((MMGraph*)(self.superview)).selectedNode.layer setBorderColor:[UIColor clearColor].CGColor];
    ((MMGraph*)(self.superview)).selectedNode = self;
    [self.layer setBorderColor:[UIColor purpleColor].CGColor];
    [self.layer setBorderWidth:3.0];

    [self setNeedsDisplay];
    
    //move to center
    
}

-(IBAction)respondToSinglePan:(UIPanGestureRecognizer*)recognizer {
    //add new node
    // moves touched node to top layer
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        [[self superview] bringSubviewToFront:self];
        [self.drawNodeDelegate setTempLineStart:self.center];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.superview];
        [self.drawNodeDelegate drawTempLineTo:point];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [recognizer locationInView:self.superview];
        
        MMNode* child = [self addChildAtPoint:point];
        [self.drawNodeDelegate addNode:child];
        [self.drawNodeDelegate drawEdgeWithView:self.childEdges[@((size_t)child)]];
    }
    else if ([recognizer state] == UIGestureRecognizerStateFailed) {
        //clear blue line if failed
        [self.drawNodeDelegate addNode:nil];
    }
}

-(IBAction)respondToDoublePan:(UIPanGestureRecognizer*)recognizer {
    [[self superview] bringSubviewToFront:self];
    
    CGPoint location = [recognizer translationInView:self.superview];
    CGPoint center = self.center;
    center.x += location.x;
    center.y += location.y;
    
    for (id child in self.children) {
        UIView* edge = self.childEdges[@((size_t)(child))];
        edge = [self changeEdge:edge FromPoint:center toPoint:((MMNode*)child).center];
    }
    UIView* edge = self.parent.childEdges[@((size_t)(self))];
    edge = [self changeEdge:edge FromPoint:center toPoint:self.parent.center];

    self.center = center;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}

@end


#pragma Graph
@interface MMGraph () {
    CGPoint beginPoint ;
    UIBezierPath* _tempLinePath;
    UIColor* _brushPattern;
    BOOL _isTempLine;
}


@end

@implementation MMGraph

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tempLinePath = [[UIBezierPath alloc] init];
        _tempLinePath.lineWidth = 3.0;
        
        _brushPattern = [UIColor blueColor];
        _isTempLine = NO;
    }
    return self;
}

-(void)setRoot:(MMNode *)root andName:(NSString *)name {
    self.root = root;
    self.mapName = name;
    [self addSubview:root];
}

-(void)drawRect:(CGRect)rect {
    
    if (_isTempLine) {
        
        [_brushPattern setStroke];
        [_tempLinePath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        [_tempLinePath stroke];
    }
    
}


#pragma protocal functions
-(void)addNode:(MMNode *)node {
    [_tempLinePath removeAllPoints];
    _isTempLine = NO;
    [self setNeedsDisplay];
    if (node)
        [self addSubview:node];
}

-(void)setTempLineStart:(CGPoint)point {
    
    [_tempLinePath moveToPoint:point];
    beginPoint = CGPointMake(point.x, point.y);
 
}

-(void)drawTempLineTo:(CGPoint)point {

    /*
    
    CGPoint beginpoint = _tempLinePath.currentPoint;
    [_tempLinePath removeAllPoints];
    [_tempLinePath moveToPoint:beginpoint];
    [_tempLinePath addLineToPoint:point];
    [self setNeedsDisplay];

    [_tempLinePath moveToPoint:beginpoint];
    
    */
    
    [_tempLinePath removeAllPoints];
    _isTempLine = YES;
    CGPoint cp2 ;
    if( point.x > 510 )
    {
        cp2 = CGPointMake(point.x-60, point.y+50);
    }
    else
    {
        cp2 = CGPointMake(point.x+60, point.y-50);
    }
        
    [_tempLinePath moveToPoint:beginPoint];
    [_tempLinePath addCurveToPoint:point controlPoint1:CGPointMake(beginPoint.x + 30, beginPoint.y-50) controlPoint2:cp2];
    
    [self setNeedsDisplay];

}

-(void)drawEdgeWithView:(UIView*)edge {
    [self addSubview:edge];
    [self sendSubviewToBack:edge];
}

- (void) drawFromNodes:(NSMutableArray*) nodes
{
    
     for (MMNode *node in nodes) {
         [self addSubview:node];
     }
}

@end
