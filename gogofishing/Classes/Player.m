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
    [_boat createPhysicBody];
    _boat.position = position;
    [_gameView addChild:_boat];
    
    
    
    power = 0;
    
}

- (void)doAcceleration:(BOOL)applyGas
{
    
    [_boat.physicsBody applyForce:ccp(0, 120.f) atPoint:_boat.position];
}

- (void)update:(CFTimeInterval)currentTime
{
    
}

@end
