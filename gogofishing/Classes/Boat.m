//
//  Boat.m
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "Boat.h"
#import "PhysicShapeBuilder.h"
#import "GameScene.h"


static const float MAX_BOAT_POWER = 60.5f;

@interface Boat ()

@property(nonatomic, assign)CGFloat             power;
@property(nonatomic, assign)CGFloat             torque;


@end

@implementation Boat

- (void)createPhysicBodyWithGameView:(GameScene*)gameView
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    CGPathMoveToPoint(path, NULL, -0.500, 27.000);
    CGPathAddLineToPoint(path, NULL, -12.500, 4.000);
    CGPathAddLineToPoint(path, NULL, -12.500, -30.000);
    CGPathAddLineToPoint(path, NULL, 13.500, -30.000);
    CGPathAddLineToPoint(path, NULL, 13.500, 4.000);
    CGPathCloseSubpath(path);
    
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = GameColliderTypeBoat;
    self.physicsBody.collisionBitMask = GameColliderTypeBoat | GameColliderTypeWall;
    self.physicsBody.contactTestBitMask = GameColliderTypeBoat | GameColliderTypeWall;
    self.physicsBody.friction = 1.0f;
    self.physicsBody.restitution = 0.09f;
    
    self.physicsBody.mass = self.physicsBody.mass * 2.0f;

    
#if DEBUG_DRAW==1
    debugBody = [PhysicShapeBuilder addPolygonShapeNodeWithSize:path withPhysicBody:NO];
    /*debugBody.physicsBody.dynamic = YES;
    debugBody.physicsBody.categoryBitMask = GameColliderTypeBoat;
    debugBody.physicsBody.collisionBitMask = 0;
    debugBody.physicsBody.contactTestBitMask = 0;
    */
    [self addChild:debugBody];

#endif

    CGPathRelease(path);
    
    
    NSLog(@" self.zRotation %f", self.zRotation);
    
    facingDirection = CGPointMake(0, 1);

    CGSize smallBox = CGSizeMake(self.size.width*0.2f, self.size.width*0.2f);
    self.thrusterBody = [PhysicShapeBuilder addBoxShapeNodeWithSize:smallBox withPhysicBody:NO];
    self.thrusterBody.position = CGPointMake(0, -self.size.height/2);
    self.thrusterBody.hidden = YES;
    
    [self addChild:self.thrusterBody];
    
    self.applyAcceleration = NO;
    self.power = 0;
    self.torque = 0;
    
}

- (void)reset
{
    self.applyAcceleration = NO;
    self.power = 0;
    self.torque = 0;
    self.physicsBody.velocity = CGPointZero;
    self.physicsBody.angularVelocity = 0;

}

- (void)update:(CFTimeInterval)currentTime
{

   // NSLog(@"Power %f", _power);
    


    //CGPoint steeringDir = CGPointZero;
    
    if( self.applyAcceleration )
    {
        
        _power+=(MAX_BOAT_POWER * currentTime);
        _power = MIN(_power, 8.0f);
        
        self.physicsBody.linearDamping = 0.4f;
        
        CGPoint vector = ccpForAngle(-self.zRotation);
        
        CGPoint forceVector = ccpMult(vector, _power);
        CGPoint newForceVector = ccp( self.goForward ? forceVector.y : -forceVector.y, self.goForward ? forceVector.x : -forceVector.x);
        //NSLog(@"forceVector %f %f", newForceVector.x, newForceVector.y);
        
        //self.steering = ccp(25.0f, 0);

        
        
        
        
        if(self.steering.x!=0)
        {
            _torque+= (self.steering.x * 0.0039f) * currentTime;
            self.physicsBody.angularDamping = 0.7f;
        }
        else
        {
            _torque = 0;
            self.physicsBody.angularDamping = 1.0f;
        }
        
        if(_torque!=0)
        {
            float maxTorque = 0.0018f;
            
            _torque = clampf(_torque, -maxTorque, maxTorque);
            
            //if( _torque>maxTorque && _torque< maxTorque )
            {
                [self.physicsBody applyTorque:-(_torque * (self.physicsBody.mass * 9.12f) )];
            }
        }
        //NSLog(@"_torque %f", self.physicsBody.mass);
        
        //NSLog(@"angleVel %f", self.physicsBody.angularVelocity);
        self.physicsBody.angularVelocity = self.physicsBody.angularVelocity * (fabsf(self.steering.x)*0.06f);
        self.physicsBody.angularVelocity = clampf(self.physicsBody.angularVelocity, -2.23f, 2.23f);
        
        
        CGPoint forcePosition = [self.thrusterBody convertPoint:self.thrusterBody.position toNode:self.parent];
        
        [self.physicsBody applyForce:ccpMult(newForceVector, self.physicsBody.mass * 25.12f) atPoint:forcePosition ];
    }
    else
    {
        _power-=( (MAX_BOAT_POWER * 6.1f) * currentTime);
        _power = MAX(_power, 0);

        _torque = (self.steering.x * 0.006f) * _power;
        
        if(_power<=0.04f)
        {
            _torque = 0;
        }
        
        
        if(_torque!=0)
        {
            _torque = clampf(_torque, -0.002f, 0.002f);
            [self.physicsBody applyTorque:-_torque];
        }
        
        //NSLog(@"_torque %f %f", _torque, _power);
        
        
        self.physicsBody.angularDamping = 1.0f;
        
        self.physicsBody.linearDamping = 1.0f - (_power/MAX_BOAT_POWER);
    }
  
   // NSLog(@"angularVelocity %f",  self.physicsBody.angularVelocity);
   // NSLog(@"Velocity %f %f", self.physicsBody.velocity.x, self.physicsBody.velocity.y);

    
}


@end
