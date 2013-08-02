//
//  PhysicShapeBuilder.m
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "PhysicShapeBuilder.h"


@implementation PhysicShapeBuilder

+ (ShapeNode*)addBallShapeNodeWithRadius:(CGFloat)radius withPhysicBody:(BOOL)usePhysics
{
    ShapeNode *shape = [[ShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, 0,0, radius, 0, M_PI*2, YES);
    shape.path = path;
    shape.fillColor = [SKColor blueColor];
    shape.strokeColor = [SKColor redColor];
    shape.antialiased = YES;
    shape.lineWidth = 1.0f;
    
    CGPathRelease(path);
    
    if( usePhysics )
    {
        shape.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    }
    
    shape.radius = radius;
    
    return shape;
}

+ (ShapeNode*)addBoxShapeNodeWithSize:(CGSize)size withPhysicBody:(BOOL)usePhysics
{
    ShapeNode *shape = [[ShapeNode alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(-size.width/2, -size.height/2, size.width, size.height));
    //CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
    
    shape.path = path;
    //shape.fillColor = [SKColor blueColor];
    shape.strokeColor = [SKColor redColor];
    shape.lineWidth = 0.4f;
    shape.antialiased = YES;
    
    CGPathRelease(path);
    
    if( usePhysics )
    {
        shape.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    }
    
    return shape;
}

@end
