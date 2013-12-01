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
@property(weak) id<MapDrawNodeDelegate> drawNodeDelegate;

+(instancetype) initRootWithPoint:(CGPoint)point AndDelegate:(id)delegate;
+(instancetype) initWithParent:(MMNode*)parent andPoint:(CGPoint)point;
-(MMNode*) addChildAtPoint:(CGPoint)point;
-(void) deleteNode;

@end

@protocol MapDrawNodeDelegate <NSObject>

-(void)addNode:(MMNode*)node;
-(void)setStartPoint:(CGPoint)point;
-(void)setDestPoint:(CGPoint)point;
-(void)isMoving;
-(void)isStop;

@end


@interface MMGraph : UIView <MapDrawNodeDelegate> {
    CGPoint start;
    CGPoint dest;
    bool isMoving;
}

@property(strong, nonatomic) NSString* mapName;
@property(strong, nonatomic) MMNode* root;

-(void)setRoot:(MMNode*)root andName:(NSString*)name;

@end

