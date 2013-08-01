//
//  RagDoll.m
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "Ragdoll.h"
#import "PhysicShapeBuilder.h"
#import "GameView.h"
#import "GameMacros.h"

@implementation Ragdoll

- (id)init
{
    if( self=[super init] )
    {
        self.draggableNodes = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}


#pragma mark - Ragdoll builder

- (void)createRagdollAtPosition:(CGPoint)position inScene:(SKScene*)scene
{
    self.scene = scene;
    
    //head
    
    CGFloat headRadius = 12.0f;
    
    SKShapeNode* head = [PhysicShapeBuilder addBallShapeNodeWithRadius:headRadius withPhysicBody:YES];
    head.physicsBody.categoryBitMask = YogaColliderTypeBody;
    head.physicsBody.collisionBitMask = YogaColliderTypeWall;
    head.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    head.physicsBody.dynamic = NO;
    head.name = @"head";
    head.position = position;
    [scene addChild:head];
    
    
    CGSize torsoSize = CGSizeMake(35, 15);
    
    
    //torso 1
    SKShapeNode* torso1 = [PhysicShapeBuilder addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso1.position = CGPointMake(head.position.x, head.position.y-(headRadius/2 + torsoSize.height));
    torso1.physicsBody.dynamic = NO;
    torso1.name = @"torso1";
    [scene addChild:torso1];
    
    
    //torso 2
    SKShapeNode* torso2 = [PhysicShapeBuilder addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso2.physicsBody.categoryBitMask = YogaColliderTypeBody;
    torso2.physicsBody.collisionBitMask = YogaColliderTypeWall;
    torso2.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    torso2.position = CGPointMake(torso1.position.x, torso1.position.y-torsoSize.height);
    torso2.physicsBody.dynamic = YES;
    torso2.name = @"torso2";
    [scene addChild:torso2];
    
    
    //torso 3
    ShapeNode* torso3 = [PhysicShapeBuilder addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso3.physicsBody.categoryBitMask = YogaColliderTypeBody;
    torso3.physicsBody.collisionBitMask = YogaColliderTypeWall;
    torso3.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    torso3.position = CGPointMake(torso2.position.x, torso2.position.y-torsoSize.height);
    torso3.physicsBody.dynamic = YES;
    torso3.name = @"torso3";
    [scene addChild:torso3];
    
    self.centreNode = torso3;
    
    //left arm
    
    CGSize armSize = CGSizeMake(10, 20);
    
    //upper arm
    SKShapeNode* upperLeftArm = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperLeftArm.name = @"leftShoulder";
    upperLeftArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    upperLeftArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperLeftArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperLeftArm.physicsBody.dynamic = NO;
    upperLeftArm.position = CGPointMake(torso1.position.x - ((torsoSize.width/2)), (torso1.position.y + torsoSize.height/2) - armSize.height/2  );
    [scene addChild:upperLeftArm];
    
    
    //lower arm
    SKShapeNode* lowerLeftArm = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerLeftArm.name = @"lowerLeftArm";
    lowerLeftArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    lowerLeftArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerLeftArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    lowerLeftArm.position = CGPointMake(upperLeftArm.position.x, upperLeftArm.position.y - armSize.height  );
    [scene addChild:lowerLeftArm];
    
    
    leftHand = [PhysicShapeBuilder addBallShapeNodeWithRadius:LIMBS_GRAB_RADIUS withPhysicBody:YES];
    leftHand.name = @"leftHand";
    leftHand.position = CGPointMake(lowerLeftArm.position.x, lowerLeftArm.position.y - armSize.height/2  );
    leftHand.physicsBody.categoryBitMask = YogaColliderTypeArm;
    leftHand.physicsBody.collisionBitMask = YogaColliderTypeWall;
    leftHand.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    leftHand.physicsBody.density = 1.0f;
    [scene addChild:leftHand];
    
    [self.draggableNodes addObject:leftHand];
    
    
    //right arm
    SKShapeNode* upperRightArm = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperRightArm.name = @"rightShoulder";
    upperRightArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    upperRightArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperRightArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    upperRightArm.position = CGPointMake(torso1.position.x + ((torsoSize.width/2)), (torso1.position.y + torsoSize.height/2) - armSize.height/2  );
    [scene addChild:upperRightArm];
    
    //lower right arm
    SKShapeNode* lowerRightArm = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerRightArm.name = @"lowerRightArm";
    lowerRightArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    lowerRightArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerRightArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    lowerRightArm.physicsBody.dynamic = YES;
    lowerRightArm.position = CGPointMake(upperRightArm.position.x, upperRightArm.position.y - armSize.height  );
    [scene addChild:lowerRightArm];
    
    rightHand = [PhysicShapeBuilder addBallShapeNodeWithRadius:LIMBS_GRAB_RADIUS withPhysicBody:YES];
    rightHand.name = @"rightHand";
    rightHand.position = CGPointMake(lowerRightArm.position.x, lowerRightArm.position.y - armSize.height/2  );
    rightHand.physicsBody.categoryBitMask = YogaColliderTypeArm;
    rightHand.physicsBody.collisionBitMask = YogaColliderTypeWall;
    rightHand.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    rightHand.physicsBody.density = 1.0f;
    [scene addChild:rightHand];
    
    [self.draggableNodes addObject:rightHand];

    
    //legs
    //left leg
    CGSize legSize = CGSizeMake(10, 20);
    
    SKShapeNode* upperLeftLeg = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperLeftLeg.name = @"upperLeftLeg";
    upperLeftLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    upperLeftLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperLeftLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperLeftLeg.physicsBody.dynamic = NO;
    upperLeftLeg.position = CGPointMake(torso3.position.x - ((torsoSize.width*0.3f)), (torso3.position.y - torsoSize.height/2) - legSize.height/2  );
    [scene addChild:upperLeftLeg];
    
    
    SKShapeNode* lowerLeftLeg = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerLeftLeg.name = @"lowerLeftLeg";
    lowerLeftLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    lowerLeftLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerLeftLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //lowerLeftLeg.physicsBody.dynamic = NO;
    lowerLeftLeg.position = CGPointMake(upperLeftLeg.position.x, upperLeftLeg.position.y - legSize.height  );
    [scene addChild:lowerLeftLeg];
    
    //right leg
    
    SKShapeNode* upperRightLeg = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperRightLeg.name = @"upperRightLeg";
    upperRightLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    upperRightLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperRightLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperRightLeg.physicsBody.dynamic = NO;
    upperRightLeg.position = CGPointMake(torso3.position.x + ((torsoSize.width*0.3f)), (torso3.position.y - torsoSize.height/2) - legSize.height/2  );
    [scene addChild:upperRightLeg];
    
    SKShapeNode* lowerRightLeg = [PhysicShapeBuilder addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerRightLeg.name = @"lowerRightLeg";
    lowerRightLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    lowerRightLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerRightLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //lowerRightLeg.physicsBody.dynamic = NO;
    lowerRightLeg.position = CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y - legSize.height  );
    [scene addChild:lowerRightLeg];
    
    
    //joints
    
    //pin head to background
    SKPhysicsJointPin* pinJoint = [SKPhysicsJointPin jointWithBodyA:scene.physicsBody bodyB:head.physicsBody anchor:head.position];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.frictionTorque = 0.2f;
    pinJoint.lowerAngleLimit = -40.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 40.0f / (180.0f / M_PI);
    // [self.physicsWorld addJoint:pinJoint];
    
    //head to torso 1
    pinJoint = [SKPhysicsJointPin jointWithBodyA:head.physicsBody bodyB:torso1.physicsBody anchor:CGPointMake(torso1.position.x, torso1.position.y+(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -40.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    pinJoint.upperAngleLimit = 40.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    //torso 1 -> torso 2
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:torso2.physicsBody anchor:CGPointMake(torso1.position.x, torso1.position.y-(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -15.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 15.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [scene.physicsWorld addJoint:pinJoint];
    
    
    
    //torso 2 -> torso 3
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso2.physicsBody bodyB:torso3.physicsBody anchor:CGPointMake(torso2.position.x, torso2.position.y-(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -15.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 15.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [scene.physicsWorld addJoint:pinJoint];
    
    
    //torso 1 to left arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:upperLeftArm.physicsBody anchor:CGPointMake(torso1.position.x - ((torsoSize.width/2)), torso1.position.y + torsoSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    
    [scene.physicsWorld addJoint:pinJoint];
    
    //upper arm to lower arm
    
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperLeftArm.physicsBody bodyB:lowerLeftArm.physicsBody anchor:CGPointMake(lowerLeftArm.position.x, lowerLeftArm.position.y+armSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.002f;
    [scene.physicsWorld addJoint:pinJoint];
    
    
    //torso 1 to right arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:upperRightArm.physicsBody anchor:CGPointMake(torso1.position.x + ((torsoSize.width/2)), torso1.position.y + torsoSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    //upper right to lower arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperRightArm.physicsBody bodyB:lowerRightArm.physicsBody anchor:CGPointMake(lowerRightArm.position.x, lowerRightArm.position.y+armSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.002f;
    [scene.physicsWorld addJoint:pinJoint];
    
    
    //left leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso3.physicsBody bodyB:upperLeftLeg.physicsBody anchor:CGPointMake(upperLeftLeg.position.x, upperLeftLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 45.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    
    //lower left leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperLeftLeg.physicsBody bodyB:lowerLeftLeg.physicsBody anchor:CGPointMake(lowerLeftLeg.position.x, lowerLeftLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 115.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    //right leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso3.physicsBody bodyB:upperRightLeg.physicsBody anchor:CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 45.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    
    //lower right leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperRightLeg.physicsBody bodyB:lowerRightLeg.physicsBody anchor:CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 115.0f / (180.0f / M_PI);
    [scene.physicsWorld addJoint:pinJoint];
    
    //hands
    
    SKPhysicsJointFixed* fixedJoint = [SKPhysicsJointFixed jointWithBodyA:lowerLeftArm.physicsBody bodyB:leftHand.physicsBody anchor:leftHand.position];
    [scene.physicsWorld addJoint:fixedJoint];
    
    fixedJoint = [SKPhysicsJointFixed jointWithBodyA:lowerRightArm.physicsBody bodyB:rightHand.physicsBody anchor:rightHand.position];
    [scene.physicsWorld addJoint:fixedJoint];
    
    
    //[upperLeftLeg.physicsBody applyAngularImpulse:0.11f];
    
    
}


- (ShapeNode*)findLimbAtPosition:(CGPoint)point
{
    
    for( ShapeNode* node in self.draggableNodes )
    {
        
        CGFloat distance = ccpDistance(point, node.position);
        if( distance<node.radius )
        {
            NSLog(@"touch inside %@", node.name);
            return node;
        }
        
    }
    
    return nil;
}

- (CGPoint)distanceBetweenCentreFromNode:(SKNode*)node
{
    return ccpSub(node.position, _centreNode.position);
}

- (BOOL)isDraggableNodeInPosition:(CGPoint)offset withNode:(SKNode*)node
{
    
    CGPoint targetNodePosition = ccpAdd(offset, _centreNode.position);
    
    CGFloat distance = ccpDistance(targetNodePosition, node.position);
    if( distance<10.0f )
    {
        return YES;
    }
    
    return NO;
}

@end
