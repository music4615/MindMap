//
//  MMCore.m
//  MindMap
//
//  Created by Mac on 13/11/28.
//  Copyright (c) 2013年 NTUEE. All rights reserved.
//

#import "MMCore.h"


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
    
    // set node images
    UIImageView* nodeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodeImg.png"]];
    CGSize imageSize = nodeImageView.frame.size;
    
    [node setFrame:CGRectMake(point.x-imageSize.width/2.0, point.y-imageSize.height/2.0, imageSize.width, imageSize.height)];
    [node addSubview:nodeImageView];
    [node setTransform:CGAffineTransformScale(node.transform, 0.3, 0.3)];
    
    [node setGestures];
    
    return node;
}

+(instancetype) initWithParent:(MMNode *)parent andPoint:(CGPoint)point{
    MMNode* node = [[MMNode alloc] init];
    node.parent = parent;
    node.children = [NSMutableArray array];
    node.childEdges = [NSMutableDictionary dictionary];
    node.drawNodeDelegate = parent.drawNodeDelegate;
    
    // set node images
    UIImageView* nodeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodeImg.png"]];
    CGSize imageSize = nodeImageView.frame.size;
    
    [node setFrame:CGRectMake(point.x-imageSize.width/2.0, point.y-imageSize.height/2.0, imageSize.width, imageSize.height)];
    [node addSubview:nodeImageView];
    [node setTransform:CGAffineTransformScale(node.transform, 0.3, 0.3)];
    
    [node setGestures];
    
    return node;
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
    ((MMGraph*)(self.superview)).selectedNode.backgroundColor = [UIColor clearColor];
    ((MMGraph*)(self.superview)).selectedNode = self;
    [self.layer setBorderColor:[UIColor blueColor].CGColor];
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
        //NSLog(@"changed");
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
        _tempLinePath.lineWidth = 0.5;
        
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
        //[_tempLinePath stroke];
    }
    
}


#pragma protocal functions
-(void)addNode:(MMNode *)node {
    [_tempLinePath removeAllPoints];
    //_isTempLine = NO;
    [self setNeedsDisplay];
    if (node)
        [self addSubview:node];
}

-(void)setTempLineStart:(CGPoint)point {
    [_tempLinePath moveToPoint:point];
 
}

-(void)drawTempLineTo:(CGPoint)point {
    _isTempLine = YES;
    CGPoint beginpoint = _tempLinePath.currentPoint;
    [_tempLinePath removeAllPoints];
    [_tempLinePath moveToPoint:beginpoint];
    [_tempLinePath addLineToPoint:point];
    [self setNeedsDisplay];

    [_tempLinePath moveToPoint:beginpoint];
    
}

-(void)drawEdgeWithView:(UIView*)edge {
    [self addSubview:edge];
    [self sendSubviewToBack:edge];
}

@end
