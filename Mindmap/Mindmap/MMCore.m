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
    
    return node;
}

-(MMNode*) addChildAtPoint:(CGPoint)point {
    MMNode* child = [MMNode initWithParent:self andPoint:point];
    double distance = sqrt(pow(self.center.x - point.x, 2.0) + pow(self.center.y - point.y, 2.0));
    double angle = atan2(self.center.y - point.y, self.center.x - point.x);
    CGPoint center = CGPointMake((self.center.x+point.x)/2.0, (self.center.y+point.y)/2.0);
    UIView* edge = [[UIView alloc] initWithFrame:CGRectMake(center.x-distance/2.0, center.y-1, distance, 2)];
    [edge setTransform:CGAffineTransformRotate(edge.transform, angle)];
    edge.backgroundColor = [UIColor redColor];
    [self.childEdges setObject:edge forKey:@((size_t)(child))];
    [self.children addObject:child];
    // add edge to child
    
    return child;
}

-(void) deleteNode {
    // add children's ptrs to parent
    [self.parent.children addObjectsFromArray:(NSArray*)self.children];
    // add parent ptr to children
    
    // add parent edge to children
    
    // remove parent's ptr to self
    [self.parent.children removeObjectIdenticalTo:self];
    // remove parent edge to self
    [self.childEdges[@((size_t)self)] removeFromSuperview];
    
}

#pragma touch to add node
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // moves touched node to top layer
    [[self superview] bringSubviewToFront:self];
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    location = point;
    UIScrollView * scrollView = (UIScrollView*)self.superview.superview;
    [scrollView setScrollEnabled:NO];
    
    [self.drawNodeDelegate setTempLineStart:self.center];
<<<<<<< HEAD
    
=======
>>>>>>> 7bd3cefd30d6476047d5bf8ff568a7996db369e9
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    /*
    CGRect frame = self.frame;
    frame.origin.x += point.x - location.x;
    frame.origin.y += point.y - location.y;
    [self setFrame:frame];
    */
    [self.drawNodeDelegate drawTempLineTo:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIScrollView * scrollView = (UIScrollView*)self.superview.superview;
    [scrollView setScrollEnabled:YES];
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    
    MMNode* child = [self addChildAtPoint:point];
    [self.drawNodeDelegate addNode:child];
    [self.drawNodeDelegate drawEdgeWithView:self.childEdges[@((size_t)child)]];
}

@end


#pragma Graph
@interface MMGraph () {
    
    UIBezierPath* tempLinePath;
    UIColor* brushPattern;
    BOOL isTempLine;
}


@end

@implementation MMGraph

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        tempLinePath = [[UIBezierPath alloc] init];
        tempLinePath.lineWidth = 0.5;
        
        brushPattern = [UIColor blueColor];
        isTempLine = NO;
    }
    return self;
}

-(void)setRoot:(MMNode *)root andName:(NSString *)name {
    self.root = root;
    self.mapName = name;
    [self addSubview:root];
}

-(void)drawRect:(CGRect)rect {
    
    if (isTempLine) {
        
        [brushPattern setStroke];
        [tempLinePath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        [tempLinePath stroke];
    }
    
<<<<<<< HEAD
    
=======
>>>>>>> 7bd3cefd30d6476047d5bf8ff568a7996db369e9
}


#pragma protocal functions
-(void)addNode:(MMNode *)node {
    [self addSubview:node];
<<<<<<< HEAD

=======
>>>>>>> 7bd3cefd30d6476047d5bf8ff568a7996db369e9
}

-(void)setTempLineStart:(CGPoint)point {
    [tempLinePath moveToPoint:point];
 
}

-(void)drawTempLineTo:(CGPoint)point {
    isTempLine = YES;
    CGPoint beginpoint = tempLinePath.currentPoint;
    [tempLinePath removeAllPoints];
    [tempLinePath moveToPoint:beginpoint];
    [tempLinePath addLineToPoint:point];
    [self setNeedsDisplay];

    [tempLinePath moveToPoint:beginpoint];
    //isTempLine = false;
    
}

-(void)drawEdgeWithView:(UIView*)edge {
    [self addSubview:edge];
    [self sendSubviewToBack:edge];
}

@end
