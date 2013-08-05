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


- (id)initPlayerAtPosition:(CGPoint)position withView:(GameView*)gameView withSpriteName:(NSString*)spriteName
{
    
    if( self=[super init] )
    {
        self.gameView = gameView;
        [self createBoatAtPosition:position withSpriteName:spriteName];

    }
    
    return self;
}

- (void)createBoatAtPosition:(CGPoint)position withSpriteName:(NSString*)spriteName
{
    _boat = [Boat spriteNodeWithImageNamed:spriteName];
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

#pragma mark - Joystick movement

- (void)joystickDidMove:(Joystick *)joystick withDeltaPosition:(CGPoint)position
{
    //NSLog(@"joystickDidMove %f", position.x);
    self.boat.steering = position;
    
}


#pragma mark - Game Button delegate

- (void)gameButtonOnPress:(GameButton*)gameButton
{
    NSLog(@"gameButtonOnPress %@", _boat.name);
    [self doAcceleration:YES];
}

- (void)gameButtonOnRelease:(GameButton*)gameButton
{
    NSLog(@"gameButtonOnRelease %@", _boat.name);
    [self doAcceleration:NO];
}

@end


