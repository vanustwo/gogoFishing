//
//  GameView.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseView.h"

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


@interface GameView : BaseView
{
    GameState                       gameState;
    CFTimeInterval                  m_timer;
    Boat*                           boat1;
}


@end

