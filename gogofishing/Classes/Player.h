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
#import "GameButton.h"

@class Boat;
@class GameScene;
@class Joystick;
@class GameButton;

@interface Player : NSObject<JoystickDelegate, GameButtonDelegate>
{
    CGFloat         power;
}

- (id)initPlayerAtPosition:(CGPoint)position withView:(GameScene*)gameView withSpriteName:(NSString*)spriteName;
- (void)createBoatAtPosition:(CGPoint)position withSpriteName:(NSString*)spriteName;
- (void)update:(CFTimeInterval)currentTime;
- (void)doAcceleration:(BOOL)applyGas;

@property(nonatomic,strong)Boat*        boat;
@property(nonatomic,strong)GameScene*    gameView;
@property(nonatomic,weak)Joystick*      joystick;
@property(nonatomic,weak)GameButton*    gameButtonA;
@property(nonatomic,weak)GameButton*    gameButtonB;
@property(nonatomic,assign)int          score;

@end
