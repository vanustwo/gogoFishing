//
//  GameView.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseView.h"
#import "Joystick.h"
#import "GameButton.h"
#import "Player.h"

@class Boat;


/* Bitmask for the different entities with physics bodies. */
typedef enum : uint32_t {
    GameColliderTypeWall            = 1 << 0,
    GameColliderTypeBoat            = 1 << 1,
} GameColliderType;

typedef enum{
    GameState_Idle,
    GameState_Start,
    GameState_PoseComplete,
    GameState_End,
}GameState;


@interface GameView : BaseView <GameButtonDelegate>
{
    GameState                       gameState;
    CFTimeInterval                  m_timer;
    Boat*                           boat1;
    Joystick*                       joystick1;
    GameButton*                     gameButton1;
    Player*                         player1;
    
}


@end

