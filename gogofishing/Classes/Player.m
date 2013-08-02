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
    [_gameView addChild:_boat];
    
    [_boat createPhysicBodyWithGameView:_gameView];
    _boat.position = position;
    
    
    
    
    power = 0;
    
}

- (void)doAcceleration:(BOOL)applyGas
{

    self.boat.applyAcceleration = applyGas;
    
    
}

- (void)update:(CFTimeInterval)currentTime
{
    [_boat update:currentTime];
}

- (void)joystickDidMove:(Joystick *)joystick withDeltaPosition:(CGPoint)position
{
    NSLog(@"joystickDidMove %f", position.x);
    
    
}


@end
