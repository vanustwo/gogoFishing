//
//  GameView.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CGPointExtension.h"
#import "ShapeNode.h"
#import "MouseJoint.h"

@interface BaseView : SKScene <SKPhysicsContactDelegate>
{

}

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval; // the previous update: loop time interval
@property (nonatomic) CFTimeInterval timeSinceLast; // the previous update: loop time interval


- (int)NToVP_X:(float)dist;
- (float)NToVP_XF:(float)dist;

- (int)NToVP_Y:(float)dist;
- (float)NToVP_YF:(float)dist;

- (CGPoint)screenCenterPoint;

@end

