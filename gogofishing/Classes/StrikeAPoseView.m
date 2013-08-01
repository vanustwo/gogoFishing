//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "StrikeAPoseView.h"
#import "Ragdoll.h"
#import "PhysicShapeBuilder.h"
#import "PosePoint.h"

#define MAX_TOUCHES             2

@implementation StrikeAPoseView

#pragma mark Init

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self initLabels];
        [self initPhysicsWorld];
        [self initMouseJoints];
        
        self.ragdoll = [[Ragdoll alloc] init];
        [self.ragdoll createRagdollAtPosition:[self screenCenterPoint] inScene:self];
        
        [self initYogaPoses];
        [self resetGame];
        
        gameState = GameState_Start;
    }
    return self;
}

- (void)initLabels
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = @"Strike a pose!";
    label.fontSize = 20;
    label.position = CGPointMake([self NToVP_X:0.5f], [self NToVP_Y:0.95f]);
    [self addChild:label];
    
    poseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    poseLabel.text = @"Well Done";
    poseLabel.fontSize = 20;
    poseLabel.position = CGPointMake([self NToVP_X:0.5f], [self NToVP_Y:0.75f]);
    [self addChild:poseLabel];
    

}

- (void)initPhysicsWorld
{
    NSLog(@"initPhysicsWorld");
    [self.physicsWorld setGravity:CGPointMake(0, -9.8f)];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //self.physicsBody.categoryBitMask = YogaColliderTypeWall;
    self.physicsBody.dynamic = NO;

    /*emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"smoke" ofType:@"sks"]];
    emitterNode.position = [self screenCenterPoint];
    [emitterNode resetSimulation];
    [self addChild:emitterNode];*/
    
    m_timer = 0;
    
}

- (void)initMouseJoints
{

    self.mouseJointArray = [NSMutableArray arrayWithCapacity:MAX_TOUCHES];
    
    //create 2 empty mouse joint
    for( int i=0;i<MAX_TOUCHES;i++ )
    {
        MouseJoint* mj = [[MouseJoint alloc] init];
       [self.mouseJointArray addObject:mj];
    }
    
}

- (void)initYogaPoses
{
    testPoint = CGPointMake(48, 63);
    
    if( !_posePointArray )
    {
        _posePointArray = [NSMutableArray arrayWithCapacity:2];
    }
    
    PosePoint* posePoint = [[PosePoint alloc] initWithPoint:testPoint inScene:self toNode:(ShapeNode*)[self childNodeWithName:@"rightHand"]];
    posePoint.ragdollCentre = _ragdoll.centreNode;
    [_posePointArray addObject:posePoint];
    
    CGPoint nodePosition = ccpAdd(posePoint.ragdollCentre.position, posePoint.offsetPoint);
    ShapeNode* node= [PhysicShapeBuilder addBallShapeNodeWithRadius:10.0f withPhysicBody:NO];
    node.position = nodePosition;
    posePoint.shapeNode = node;
    [self addChild:node];

    posePoint = [[PosePoint alloc] initWithPoint:CGPointMake(-48, 63) inScene:self toNode:(ShapeNode*)[self childNodeWithName:@"leftHand"]];
    posePoint.ragdollCentre = _ragdoll.centreNode;
    [_posePointArray addObject:posePoint];
    
    nodePosition = ccpAdd(posePoint.ragdollCentre.position, posePoint.offsetPoint);
    node= [PhysicShapeBuilder addBallShapeNodeWithRadius:10.0f withPhysicBody:NO];
    node.position = nodePosition;
    posePoint.shapeNode = node;
    [self addChild:node];
    
}

- (void)resetGame
{
    poseLabel.hidden = YES;
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"location %f %f", location.x, location.y);

        for( MouseJoint* joint in self.mouseJointArray )
        {
            if( !joint.touch && !joint.mouseJoint )
            {
                ShapeNode *node = [self.ragdoll findLimbAtPosition:location];
                
                BOOL touchedLimb = false;
                
                CGFloat distance = ccpDistance(location, node.position);
                if( distance<node.radius )
                {
                    NSLog(@"touch inside %@", node.name);
                    touchedLimb = true;
                }
                
                if( touchedLimb )
                {
                    [joint destroyMouseJoint];
                    [joint createMouseNodeAtPoint:location withNode:node inScene:self withTouch:touch];
                    joint.currentPosition = location;
                    break;
                }
            
            }
        }
        
       
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
    
        
        for( MouseJoint* joint in self.mouseJointArray )
        {
            if( joint.touch && joint.touch==touch  )
            {
                if( joint.mouseJoint )
                {
                    joint.currentPosition = location;
                }
               
            }
            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        for( MouseJoint* joint in self.mouseJointArray )
        {
            if( joint.touch && joint.touch==touch  )
            {
                [joint destroyMouseJoint];
            }
        }
        
        
    }
}

#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    
    //NSLog(@"Time passed %f", self.timeSinceLast);
    
    switch (gameState) {
        case GameState_Start:
        {
            for( MouseJoint* joint in self.mouseJointArray )
            {
                if( joint.touch && joint.mouseJoint )
                {
                    
                   // CGPoint point = [self.ragdoll distanceBetweenCentreFromNode:joint.dragNode];
                   //  NSLog(@"node %@ %f %f", joint.dragNode.name, point.x, point.y);
                    //joint.currentPosition = location;
                    //[self.ragdoll isDraggableNodeInPosition:testPoint withNode:joint.dragNode];
                    
                    for( PosePoint* posePoint in _posePointArray )
                    {
                        if( !posePoint.snapLimbInPosePoint )
                        {
                            if([self isLimbInPosePoint:posePoint])
                            {
                                NSLog(@"posePoint %@ in position", posePoint.limbNode.name);
                                [joint destroyMouseJoint];
                                [self snapLimbToPosePoint:posePoint];
                                break;
                            }
                            else
                            {
                                joint.mouseNode.position = joint.currentPosition;
                            }
                        }
                        
                    }
                }
                
            }
            
            if( [self hasCompletedPose] )
            {
                gameState = GameState_PoseComplete;
                m_timer = 0;
                poseLabel.hidden = NO;
                
            }

            
        }
            break;
        case GameState_PoseComplete:
        {
            m_timer+=self.timeSinceLast;
            
            if( m_timer>=3.0f )
            {
                //NSLog(@"Delay finished");
            }
            
        }break;
        default:
            break;
    }
    
    
}

#pragma mark - Physics

- (void)didSimulatePhysics
{
    
    switch (gameState) {
        case GameState_Start:
        {
            for( PosePoint* posePoint in _posePointArray )
            {
                if( posePoint.snapLimbInPosePoint )
                {
                   // NSLog(@"change to non dynamic body");
                  //  posePoint.limbNode.physicsBody.dynamic = NO;
                }
                
            }
        }break;
        default:break;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"didBeginContact");
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
   // NSLog(@"didEndContact");
}

#pragma mark - Posing

- (BOOL)isLimbInPosePoint:(PosePoint*)posePoint
{
    CGPoint targetNodePosition = ccpAdd(posePoint.offsetPoint, posePoint.ragdollCentre.position);
    
    CGFloat distance = ccpDistance(targetNodePosition, posePoint.limbNode.position);
    if( distance<10.0f )
    {
        return YES;
    }
    
    
    return NO;
}

- (void)snapLimbToPosePoint:(PosePoint *)posePoint
{
    if(!posePoint.snapLimbInPosePoint)
    {
        NSLog( @"snapLimbToPosePoint %@", posePoint.limbNode.name );
        CGPoint targetNodePosition = ccpAdd(posePoint.offsetPoint, posePoint.ragdollCentre.position);
        posePoint.snapLimbInPosePoint = YES;
        posePoint.limbNode.position = targetNodePosition;
        
        //snap the limb and reset bit mask
        posePoint.limbNode.physicsBody.dynamic = NO;
        posePoint.limbNode.physicsBody.categoryBitMask = 0;
        posePoint.limbNode.physicsBody.collisionBitMask = 0;
        posePoint.limbNode.physicsBody.contactTestBitMask = 0;
        
    }
}

- (bool)hasCompletedPose
{
    for( PosePoint* posePoint in _posePointArray )
    {
        if( !posePoint.snapLimbInPosePoint )
        {
            return false;
        }
    }
    
    return true;
}


@end
