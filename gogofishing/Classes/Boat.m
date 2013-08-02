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
#import "GameMacros.h"

static const float MAX_BOAT_POWER = 15.5f;

@interface Boat ()

@property(nonatomic, assign)CGFloat             power;

@end

@implementation Boat

- (void)createPhysicBodyWithGameView:(GameView*)gameView
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = GameColliderTypeBoat;
    self.physicsBody.collisionBitMask = GameColliderTypeBoat | GameColliderTypeWall;
    self.physicsBody.contactTestBitMask = GameColliderTypeBoat | GameColliderTypeWall;
    self.physicsBody.friction = 1.0f;

    
    debugBody = [PhysicShapeBuilder addBoxShapeNodeWithSize:self.size withPhysicBody:YES];
    debugBody.physicsBody.dynamic = YES;
    debugBody.physicsBody.categoryBitMask = GameColliderTypeBoat;
    debugBody.physicsBody.collisionBitMask = 0;
    debugBody.physicsBody.contactTestBitMask = 0;
    
    
    [self addChild:debugBody];
    
    
    NSLog(@" self.zRotation %f", self.zRotation);
    
    facingDirection = CGPointMake(0, 1);

    CGSize smallBox = CGSizeMake(self.size.width*0.2f, self.size.width*0.2f);
    self.thrusterBody = [PhysicShapeBuilder addBoxShapeNodeWithSize:smallBox withPhysicBody:NO];
    self.thrusterBody.position = CGPointMake(0, -self.size.height/2);
    [self addChild:self.thrusterBody];

    self.zRotation = CC_DEGREES_TO_RADIANS(-0.f);
    self.applyAcceleration = NO;
    self.power = 0;
    
}

- (void)update:(CFTimeInterval)currentTime
{

   // NSLog(@"Power %f", _power);

    //CGPoint steeringDir = CGPointZero;
    
    if( self.applyAcceleration )
    {
        _power+=(MAX_BOAT_POWER * currentTime);
        _power = MIN(_power, 10.0f);
        self.physicsBody.linearDamping = 0.1f;
        
        CGPoint vector = ccpForAngle(-self.zRotation);
        
        CGPoint forceVector = ccpMult(vector, _power);
        CGPoint newForceVector = ccp(forceVector.y, forceVector.x);
       // NSLog(@"forceVector %f %f", newForceVector.x, newForceVector.y);
        
        //self.steering = ccp(25.0f, 0);
        
        CGFloat torque = (self.steering.x * 0.001f) * currentTime;
        
        //self.physicsBody.angularDamping = 0.2f;
        [self.physicsBody applyTorque:-torque];
        
        CGPoint forcePosition = [self.thrusterBody convertPoint:self.thrusterBody.position toNode:self.parent];
        //NSLog(@"thrusterBody %f %f", a.x, a.y);
        
        [self.physicsBody applyForce:newForceVector atPoint:forcePosition ];
    }
    else
    {
        _power-=(MAX_BOAT_POWER * currentTime);
        _power = MAX(_power, 0);
        self.physicsBody.angularDamping = 0.6f;
        
        self.physicsBody.linearDamping = 1.0f - (_power/MAX_BOAT_POWER);
    }

    //CGPoint newVel = ccpAdd(self.physicsBody.velocity, steeringDir);
    
   // self.physicsBody.velocity = newVel;
    
   // NSLog(@"angularVelocity %f",  self.physicsBody.angularVelocity);
   // NSLog(@"Velocity %f %f", self.physicsBody.velocity.x, self.physicsBody.velocity.y);

    
}


@end
