//
//  PhysicShapeBuilder.h
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ShapeNode.h"

@interface PhysicShapeBuilder : NSObject
{
    
    
}


+ (ShapeNode*)addBallShapeNodeWithRadius:(CGFloat)radius withPhysicBody:(BOOL)usePhysics;
+ (ShapeNode*)addBoxShapeNodeWithSize:(CGSize)size withPhysicBody:(BOOL)usePhysics;
+ (ShapeNode*)addPolygonShapeNodeWithSize:(CGSize)size withPhysicBody:(BOOL)usePhysics;


@end
