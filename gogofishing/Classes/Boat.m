//
//  Boat.m
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "Boat.h"
#import "PhysicShapeBuilder.h"
#import "GameView.h"



@interface Boat (Private)


@end

@implementation Boat

- (void)createPhysicBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = GameColliderTypeBoat;
    self.physicsBody.collisionBitMask = GameColliderTypeBoat | GameColliderTypeWall;
    self.physicsBody.contactTestBitMask = GameColliderTypeBoat | GameColliderTypeWall;

    //self.anchorPoint = CGPointMake(0.5f, 0.1f);

    debugBody = [PhysicShapeBuilder addBoxShapeNodeWithSize:self.size withPhysicBody:YES];
    debugBody.physicsBody.dynamic = YES;
    debugBody.physicsBody.categoryBitMask = GameColliderTypeBoat;
    debugBody.physicsBody.collisionBitMask = 0;
    debugBody.physicsBody.contactTestBitMask = 0;
    
    [self addChild:debugBody];
    
    facingDirection = CGPointMake(0, 1);
    
    
}




@end
