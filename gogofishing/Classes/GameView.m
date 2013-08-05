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
        [self initPlayers];
        [self resetGame];
        

    }
    return self;
}

- (void)initLabels
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = @"Go Fishing";
    label.fontSize = 20;
    label.position = CGPointMake( NToVP_X(0.5f), NToVP_Y(0.95f));
    [self addChild:label];
    
}

- (void)initPhysicsWorld
{
    NSLog(@"initPhysicsWorld");
    [self.physicsWorld setGravity:CGPointMake(0, 0)];
    self.physicsWorld.contactDelegate = self;

    CGFloat borderPadding = NToVP_YF(0.15f);
    
    //create wall
    CGRect rect = self.frame;
    rect.size.height = NToVP_YF(1.0f) - (borderPadding*2);

    borderShapeNode =  [[SKShapeNode alloc] init];
    borderShapeNode.name = @"border";
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, rect);
    borderShapeNode.path = path;
    borderShapeNode.strokeColor = [SKColor redColor];
    borderShapeNode.lineWidth = 0.4f;
    borderShapeNode.antialiased = YES;
    CGPathRelease(path);
    
    borderShapeNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
    borderShapeNode.physicsBody.categoryBitMask = GameColliderTypeWall;
    borderShapeNode.physicsBody.dynamic = NO;
    borderShapeNode.physicsBody.friction = 1.0f;
    borderShapeNode.physicsBody.restitution = 0;
    
    borderShapeNode.position = ccp(0, borderPadding);
    [self addChild:borderShapeNode];
    
    m_timer = 0;
    
}

- (void)initPlayers
{
    
    self.playersArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    CGFloat player1JoystickY = borderShapeNode.position.y /2;
    
    //Player 1
    player1 = [[Player alloc] initPlayerAtPosition:ccp( NToVP_XF(0.5f), borderShapeNode.position.y + NToVP_YF(0.1f)) withView:self withSpriteName:@"redboat.png"];
    Joystick* joystick1 = [[Joystick alloc] initAtPosition:ccp( NToVP_XF(0.5f), player1JoystickY ) joystickRadius:NToVP_X(0.03f) joystickMoveRadius:NToVP_X(0.06f) ];
    joystick1.joystickPosition = Joystick_Position_Bottom;
    player1.joystick = joystick1;
    player1.joystick.delegate = player1;
    player1.boat.name = @"Player 1";
    [self addChild:joystick1];

    GameButton* gameButton1 = [[GameButton alloc] initAtPosition:ccp( joystick1.position.x + joystick1.joystickMoveRadius + NToVP_X(0.1f), player1JoystickY) withLabel:@"A" withRadius:NToVP_X(0.03f)];
    player1.gameButtonA = gameButton1;
    player1.gameButtonA.delegate = player1;
    [self addChild:gameButton1];
    
    [self.playersArray addObject:player1];
    
    //player 2
    CGFloat player2JoystickY = NToVP_YF(1.0f) - (borderShapeNode.position.y/2);
    player2 = [[Player alloc] initPlayerAtPosition:ccp( NToVP_XF(0.5f), NToVP_YF(1.0f) - (borderShapeNode.position.y + NToVP_YF(0.1f)) ) withView:self withSpriteName:@"yellowboat.png"];
    player2.boat.zRotation = CC_DEGREES_TO_RADIANS(-180.f);
    player2.boat.name = @"Player 2";
    
    Joystick* joystick2 = [[Joystick alloc] initAtPosition:ccp( NToVP_XF(0.5f), player2JoystickY ) joystickRadius:NToVP_X(0.03f) joystickMoveRadius:NToVP_X(0.06f) ];
    joystick2.joystickPosition = Joystick_Position_Top;
    
    player2.joystick = joystick2;
    player2.joystick.delegate = player2;
    [self addChild:joystick2];

    GameButton* gameButton2 = [[GameButton alloc] initAtPosition:ccp( joystick2.position.x + joystick2.joystickMoveRadius + NToVP_X(0.1f), player2JoystickY) withLabel:@"A" withRadius:NToVP_X(0.03f)];
    player2.gameButtonA = gameButton2;
    player2.gameButtonA.delegate = player2;
    [self addChild:gameButton2];
    
    [self.playersArray addObject:player2];
}

- (void)resetGame
{
    gameState = GameState_Start;
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
     
        
        for( Player* player in self.playersArray )
        {
            if([player.joystick.touch isEqual:touch])
            {
                NSLog(@"%@ touched joyStick 1", player.boat.name );
                break;
            }
            else
            {
                if([player.joystick touchBegan:touch withTouchPosition:location])
                {
                    NSLog(@"%@ touched joyStick 2", player.boat.name );

                    break;
                }
            }
            
            
            if([player.gameButtonA.touch isEqual:touch])
            {
                NSLog(@"%@ touched gameButtonA 1", player.boat.name );
                break;
            }
            else
            {
                if([player.gameButtonA touchBegan:touch withTouchPosition:location])
                {
                    NSLog(@"%@ touched gameButtonA 2", player.boat.name );
                    break;
                }
            }
        }
        
        //NSLog(@"location %f %f", location.x, location.y);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        for( Player* player in self.playersArray )
        {
            if([player.joystick.touch isEqual:touch])
            {
                [player.joystick touchMove:touch withTouchPosition:location];
                continue;
            }
            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        for( Player* player in self.playersArray )
        {
            [player.joystick touchEnd:touch withTouchPosition:CGPointZero];
            [player.gameButtonA touchEnd:touch withTouchPosition:CGPointZero];
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
         
            for( Player* player in self.playersArray )
            {
                if(player.joystick)
                {
                    [player.joystick update:self.timeSinceLast];
                }
                
                [player update:self.timeSinceLast];
            }

        }
            break;
        case GameState_End:
        {
            
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

@end
