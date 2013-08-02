//
//  Player.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Joystick.h"

@class Boat;
@class GameView;
@class Joystick;

@interface Player : NSObject<JoystickDelegate>
{
    CGFloat         power;
}

- (id)initPlayerAtPosition:(CGPoint)position withView:(GameView*)gameView;
- (void)createBoatAtPosition:(CGPoint)position;
- (void)update:(CFTimeInterval)currentTime;
- (void)doAcceleration:(BOOL)applyGas;

@property(nonatomic,strong)Boat*        boat;
@property(nonatomic,strong)GameView*    gameView;
@property(nonatomic,weak)Joystick*      joystick;


@end
