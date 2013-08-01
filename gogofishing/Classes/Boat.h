//
//  Boat.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShapeNode.h"

@interface Boat : SKSpriteNode
{
    SKNode*             debugBody;
    CGPoint             facingDirection;
}

@property(nonatomic, assign)CGPoint boatThrustPoint;

- (void)createPhysicBody;


@end
