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
    node.drawNodeDelegate = delegate;
    
    UIImageView* nodeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodeImage.png"]];
    CGSize imageSize = nodeImageView.frame.size;
    
    [node setFrame:CGRectMake(point.x, point.y, imageSize.width, imageSize.height)];
    [node addSubview:nodeImageView];
    
    return node;
}

+(instancetype) initWithParent:(MMNode *)parent andPoint:(CGPoint)point{
    MMNode* node = [[MMNode alloc] init];
    node.parent = parent;
    node.children = [NSMutableArray array];
    node.drawNodeDelegate = parent.drawNodeDelegate;
    
    UIImageView* nodeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodeImage.png"]];
    CGSize imageSize = nodeImageView.frame.size;
    
    [node setFrame:CGRectMake(point.x, point.y, imageSize.width, imageSize.height)];
    [node addSubview:nodeImageView];
    
    return node;
}

-(MMNode*) addChildAtPoint:(CGPoint)point {
    MMNode* child = [MMNode initWithParent:self andPoint:point];
    [self.children addObject:child];
    return child;
}

-(void) deleteNode {
    [self.parent.children addObjectsFromArray:(NSArray*)self.children];
    [self.parent.children removeObjectIdenticalTo:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //將被觸碰到鍵移動到所有畫面的最上層
    [[self superview] bringSubviewToFront:self];
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    location = point;
    UIScrollView * scrollView = (UIScrollView*)self.superview.superview;
    [scrollView setScrollEnabled:NO];
    
    //[self.drawNodeDelegate setStartPoint:point];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    /*
    CGRect frame = self.frame;
    
    frame.origin.x += point.x - location.x;
    frame.origin.y += point.y - location.y;
    [self setFrame:frame];
    */
    //[self.drawNodeDelegate isMoving];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIScrollView * scrollView = (UIScrollView*)self.superview.superview;
    [scrollView setScrollEnabled:YES];
    
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    //[self.drawNodeDelegate setDestPoint:point];
    [self.drawNodeDelegate addNode:[self addChildAtPoint:point]];
}

@end


// GRAPH
@interface MMGraph () {
    bool nodeIsTouched;
    MMNode* touchedNode;
    CGPoint pointA;
}


@end

@implementation MMGraph

-(id) init {
    self = [super init];
    if (self) {
        //CGContextRef context = UIGraphicsGetCurrentContext();
        //CGContextRetain(context);
    }
    return self;
}

-(void)setRoot:(MMNode *)root andName:(NSString *)name {
    self.root = root;
    self.mapName = name;
    start = dest = CGPointMake(0, 0);
    isMoving = false;
    [self addSubview:root];
}



-(void)addNode:(MMNode *)node {
    [self addSubview:node];
    [self setNeedsDisplay];
}

@end
