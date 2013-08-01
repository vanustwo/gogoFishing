//
//  Player.m
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "Player.h"
#import "Boat.h"
#import "GameView.h"
#import "GameMacros.h"

@implementation Player


- (id)initPlayerAtPosition:(CGPoint)position withView:(GameView*)gameView
{
    
    if( self=[super init] )
    {
        self.gameView = gameView;
        [self createBoatAtPosition:position];
        
        
    }
    
    return self;
}

- (void)createBoatAtPosition:(CGPoint)position
{
    _boat = [Boat spriteNodeWithImageNamed:@"redboat.png"];
    [_boat createPhysicBodyWithGameView:_gameView];
    _boat.position = position;
    [_gameView addChild:_boat];
    
    
    
    power = 0;
    
}

- (void)doAcceleration:(BOOL)applyGas
{
    
    float force = 50;
    CGPoint vector = ccpForAngle(-_boat.zRotation);
    
    CGPoint forceVector = ccpMult(vector, force);
    CGPoint newForceVector = ccp(forceVector.y, forceVector.x);
    NSLog(@"forceVector %f %f", newForceVector.x, newForceVector.y);
    
    
    
    
    
    
    [_boat.physicsBody applyForce:newForceVector atPoint:_boat.position];
    
}

- (void)update:(CFTimeInterval)currentTime
{
    
}

@end
