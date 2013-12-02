//
//  MMCore.h
//  MindMap
//
//  Created by Mac on 13/11/28.
//  Copyright (c) 2013年 NTUEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapDrawNodeDelegate;


@interface MMNode : UIView {
    CGPoint location;
}

@property(weak, nonatomic) MMNode* parent;
@property(strong, nonatomic) NSMutableArray* children;
@property(strong, nonatomic) NSMutableDictionary* childEdges;
@property(weak) id<MapDrawNodeDelegate> drawNodeDelegate;


+(instancetype) initRootWithPoint:(CGPoint)point AndDelegate:(id)delegate;
+(instancetype) initWithParent:(MMNode*)parent andPoint:(CGPoint)point;
-(MMNode*) addChildAtPoint:(CGPoint)point;
-(void) deleteNode;

@end

@protocol MapDrawNodeDelegate <NSObject>

-(void)addNode:(MMNode*)node;
-(void)setTempLineStart:(CGPoint)Point;
-(void)drawTempLineTo:(CGPoint)point;
-(void)drawEdgeWithView:(UIView*)edge;

@end


@interface MMGraph : UIView <MapDrawNodeDelegate> {

}

@property(strong, nonatomic) NSString* mapName;
@property(strong, nonatomic) MMNode* root;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)setRoot:(MMNode*)root andName:(NSString*)name;

@end

