//
//  Boat.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShapeNode.h"
#import "GameMacros.h"

@class GameScene;

@interface Boat : SKSpriteNode
{
    SKNode*             debugBody;
    CGPoint             facingDirection;
    
}

@property(nonatomic, assign)CGPoint     boatThrustPoint;
@property(nonatomic, strong)SKNode*     thrusterBody;
@property(nonatomic, assign)BOOL        applyAcceleration;
@property(nonatomic, assign)CGPoint     steering;


- (void)createPhysicBodyWithGameView:(GameScene*)gameView;
- (void)update:(CFTimeInterval)currentTime;
- (void)reset;

@end
