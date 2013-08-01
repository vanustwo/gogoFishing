//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameView.h"
#import "PhysicShapeBuilder.h"
#import "Boat.h"
#import "Joystick.h"

#define MAX_TOUCHES             2

@implementation GameView

#pragma mark Init

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self initLabels];
        [self initPhysicsWorld];
        //[self createBoats];
        [self initPlayers];
        [self resetGame];
        
        gameState = GameState_Start;
    }
    return self;
}

- (void)initLabels
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = @"Go Fishing";
    label.fontSize = 20;
    label.position = CGPointMake([self NToVP_X:0.5f], [self NToVP_Y:0.95f]);
    [self addChild:label];
    
}

- (void)initPhysicsWorld
{
    NSLog(@"initPhysicsWorld");
    [self.physicsWorld setGravity:CGPointMake(0, 0)];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = GameColliderTypeWall;
    self.physicsBody.dynamic = NO;

    m_timer = 0;
    
}

- (void)createBoats
{
    boat1 = [Boat spriteNodeWithImageNamed:@"redboat.png"];
    [boat1 createPhysicBody];
    boat1.position = [self screenCenterPoint];
    [self addChild:boat1];
}

- (void)initPlayers
{
    player1 = [[Player alloc] initPlayerAtPosition:[self screenCenterPoint] withView:self];
    
    joystick1 = [[Joystick alloc] initAtPosition:ccp([self NToVP_XF:0.5f], [self NToVP_YF:0.2f])];
    joystick1.delegate = self;
    [self addChild:joystick1];
    
    player1.joystick = joystick1;
    
    
    gameButton1 = [[GameButton alloc] initAtPosition:ccp([self NToVP_XF:0.7f], [self NToVP_YF:0.2f])];
    gameButton1.delegate = self;
    [self addChild:gameButton1];
    
}

- (void)resetGame
{
   
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
     
        [joystick1 touchBegan:touch withTouchPosition:location];
        
        [gameButton1 touchBegan:touch withTouchPosition:location];
        
        
        //NSLog(@"location %f %f", location.x, location.y);

        //[boat1.physicsBody applyForce:ccp(0, 20.2f) atPoint:boat1.position];
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        [joystick1 touchMove:touch withTouchPosition:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        
        [joystick1 touchEnd:touch withTouchPosition:CGPointZero];
        [gameButton1 touchEnd:touch withTouchPosition:CGPointZero];
    }
}

#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    
    //NSLog(@"Time passed %f", self.timeSinceLast);
    
    switch (gameState) {
        case GameState_Start:
        {
            
            if(joystick1)
            {
                [joystick1 update:self.timeSinceLast];
            }

            [player1 update:self.timeSinceLast];
            
        }
            break;

        default:
            break;
    }
    
    
}

#pragma mark - Physics

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"didBeginContact");
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
   // NSLog(@"didEndContact");
}

#pragma mark - Joystick input

- (void)joystickDidMove:(Joystick *)joystick withDeltaPosition:(CGPoint)position
{
    //NSLog(@"joystickDidMove");
    
    
    
}

#pragma mark - Button Input

- (void)gameButtonOnPress:(GameButton *)gameButton
{
    NSLog(@"gameButtonOnPress");
    
    [player1 doAcceleration:YES];
    
}

- (void)gameButtonOnRelease:(GameButton*)gameButton
{
    NSLog(@"gameButtonOnRelease");
    [player1 doAcceleration:NO];

}


@end
