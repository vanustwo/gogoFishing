//
//  Boat.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShapeNode.h"

@class GameView;

@interface Boat : SKSpriteNode
{
    SKNode*             debugBody;
    SKNode*             thrusterBody;
    
    CGPoint             facingDirection;
}

@property(nonatomic, assign)CGPoint boatThrustPoint;

- (void)createPhysicBodyWithGameView:(GameView*)gameView;


@end
