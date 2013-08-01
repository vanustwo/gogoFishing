//
//  PosePoint.h
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class ShapeNode;

@interface PosePoint : NSObject
{
    SKScene*        scene;
}

@property( nonatomic, assign )CGPoint        offsetPoint;
@property( nonatomic, weak )ShapeNode*       shapeNode;
@property( nonatomic, strong )ShapeNode*     limbNode;
@property( nonatomic, strong )ShapeNode*     ragdollCentre;
@property( nonatomic, assign )BOOL           snapLimbInPosePoint;

- (id)initWithPoint:(CGPoint)point inScene:(SKScene*)scene toNode:(ShapeNode*)node;
- (void)setPosePoint:(CGPoint)point inScene:(SKScene*)scene toNode:(ShapeNode*)node;



@end
