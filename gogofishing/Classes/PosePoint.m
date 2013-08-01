//
//  PosePoint.m
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "PosePoint.h"
#import "ShapeNode.h"
#import "PhysicShapeBuilder.h"
#import "CGPointExtension.h"

@implementation PosePoint

- (id)initWithPoint:(CGPoint)point inScene:(SKScene*)_scene toNode:(ShapeNode*)node;
{
    if ( self=[super init] ) {
        [self setPosePoint:point inScene:_scene toNode:node];
    }
    
    return self;
}

- (void)setPosePoint:(CGPoint)point inScene:(SKScene*)_scene toNode:(ShapeNode*)node
{
    _offsetPoint = point;
    scene = _scene;
    _limbNode = node;
    _snapLimbInPosePoint = NO;
    
    if(!_shapeNode)
    {
      /*  CGPoint nodePosition = ccpAdd(self.ragdoll.centreNode.position, testPoint);
        ShapeNode* node= [PhysicShapeBuilder addBallShapeNodeWithRadius:10.0f withPhysicBody:NO];
        node.position = nodePosition;
        [self addChild:node];*/
        
        
        
        
    }
}



@end
