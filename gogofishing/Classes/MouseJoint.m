//
//  MouseJoint.m
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "MouseJoint.h"

@implementation MouseJoint


- (void)createMouseNodeAtPoint:(CGPoint)point withNode:(SKNode *)node inScene:(SKScene*)scene withTouch:(UITouch*)touch
{
    float width = 10;
    self.mouseNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(width, width)];
    self.mouseNode.position = point;
    [scene addChild:self.mouseNode];
    
    SKPhysicsBody *mouseBody = [SKPhysicsBody bodyWithCircleOfRadius:width];
    
    //disable collision
    mouseBody.categoryBitMask = 0;
    mouseBody.contactTestBitMask = 0;
    mouseBody.collisionBitMask = 0;
    
    [mouseBody setDynamic:NO];
    [self.mouseNode setPhysicsBody:mouseBody];
    
    self.mouseJoint = [SKPhysicsJointLimit jointWithBodyA:node.physicsBody bodyB:self.mouseNode.physicsBody anchorA:node.position anchorB:point];
    self.mouseJoint.maxLength = 35;
    [scene.physicsWorld addJoint:self.mouseJoint];
    
    self.dragNode = node;
    self.scene = scene;
    self.touch = touch;
}

- (void)destroyMouseJoint
{
    if (self.mouseNode) {
        [self.mouseNode removeFromParent];
        self.mouseNode = nil;
    }
    
    if (self.mouseJoint) {
        [self.scene.physicsWorld removeJoint:self.mouseJoint];
        self.mouseJoint = nil;
    }
    
    if( self.touch )
    {
        self.touch = nil;
    }
}

@end
