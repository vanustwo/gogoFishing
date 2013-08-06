//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameScene.h"
#import "PhysicShapeBuilder.h"
#import "Boat.h"
#import "Joystick.h"

#define MAX_TOUCHES             2

@implementation GameScene

#pragma mark Init

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self initPhysicsWorld];
        [self initPlayers];
        [self initLabels];
        [self initFishes];
        [self initRocks];
        [self resetGame];
        

    }
    return self;
}

- (void)initLabels
{
    CGFloat player1JoystickY = borderShapeNode.position.y /2;
    
    self.player1ScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    self.player1ScoreLabel.text = @"Player 1";
    self.player1ScoreLabel.fontSize = 30;
    self.player1ScoreLabel.position = CGPointMake( NToVP_X(0.5f), player1JoystickY);
    [self addChild:self.player1ScoreLabel];
    
    self.player2ScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    self.player2ScoreLabel.text = @"Player 1";
    self.player2ScoreLabel.fontSize = 30;
    self.player2ScoreLabel.position = CGPointMake( NToVP_X(0.5f), NToVP_Y(1.0f) - player1JoystickY );
    [self addChild:self.player2ScoreLabel];
    self.player2ScoreLabel.yScale = -1;
    self.player2ScoreLabel.xScale = -1;
    
    [self updateScoreLabels];
    
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
    CGFloat joyStickRadius = NToVP_X(0.044f);
    CGFloat joyStickMoveRadius = NToVP_X(0.073f);
    CGFloat controlsPadding = NToVP_X(0.07f);
    CGFloat buttonRadius = NToVP_X(0.045f);
    
    {
        //Player 1
        player1 = [[Player alloc] initPlayerAtPosition:ccp( NToVP_XF(0.5f), borderShapeNode.position.y + NToVP_YF(0.1f)) withView:self withSpriteName:@"redboat.png"];
        
        Joystick* joystick1 = [[Joystick alloc] initAtPosition:ccp( joyStickMoveRadius + controlsPadding, player1JoystickY ) joystickRadius:joyStickRadius joystickMoveRadius:joyStickMoveRadius ];
        joystick1.joystickPosition = Joystick_Position_Bottom;
        player1.joystick = joystick1;
        player1.joystick.delegate = player1;
        player1.boat.name = @"Player 1";
        [self addChild:joystick1];

        GameButton* gameButtonA = [[GameButton alloc] initAtPosition:ccp( NToVP_X(0.8f) - (buttonRadius + controlsPadding) , player1JoystickY) withLabel:@"B" withRadius:buttonRadius];
        gameButtonA.gameButtonType = GameButtonType_Brake;
        player1.gameButtonA = gameButtonA;
        player1.gameButtonA.delegate = player1;
        [self addChild:gameButtonA];
        
        GameButton* gameButtonB = [[GameButton alloc] initAtPosition:ccp( NToVP_X(1.0f) - (buttonRadius + controlsPadding) , player1JoystickY) withLabel:@"A" withRadius:buttonRadius];
        gameButtonB.gameButtonType = GameButtonType_Accelerate;
        player1.gameButtonB = gameButtonB;
        player1.gameButtonB.delegate = player1;
        [self addChild:gameButtonB];
        
        
        [self.playersArray addObject:player1];
    }
    
    {
        //player 2
        CGFloat player2JoystickY = NToVP_YF(1.0f) - (borderShapeNode.position.y/2);
        player2 = [[Player alloc] initPlayerAtPosition:ccp( NToVP_XF(0.5f), NToVP_YF(1.0f) - (borderShapeNode.position.y + NToVP_YF(0.1f)) ) withView:self withSpriteName:@"yellowboat.png"];
        player2.boat.zRotation = CC_DEGREES_TO_RADIANS(-180.f);
        player2.boat.name = @"Player 2";
        
        Joystick* joystick2 = [[Joystick alloc] initAtPosition:ccp( NToVP_XF(1.0f) - (joyStickMoveRadius + controlsPadding), player2JoystickY ) joystickRadius:joyStickRadius joystickMoveRadius:joyStickMoveRadius ];
        joystick2.joystickPosition = Joystick_Position_Top;
        
        player2.joystick = joystick2;
        player2.joystick.delegate = player2;
        [self addChild:joystick2];

        GameButton* gameButton2 = [[GameButton alloc] initAtPosition:ccp( NToVP_X(0.2f) +  (buttonRadius + controlsPadding), player2JoystickY) withLabel:@"B" withRadius:buttonRadius];
        gameButton2.gameButtonType = GameButtonType_Brake;
        gameButton2.zRotation = CC_DEGREES_TO_RADIANS(-180.f);
        player2.gameButtonA = gameButton2;
        player2.gameButtonA.delegate = player2;
        [self addChild:gameButton2];
        
        
        GameButton* gameButtonB = [[GameButton alloc] initAtPosition:ccp( (buttonRadius + controlsPadding) , player2JoystickY) withLabel:@"A" withRadius:buttonRadius];
        gameButtonB.gameButtonType = GameButtonType_Accelerate;
        player2.gameButtonB = gameButtonB;
        gameButtonB.zRotation = CC_DEGREES_TO_RADIANS(-180.f);
        player2.gameButtonB.delegate = player2;
        [self addChild:gameButtonB];
        
        
        [self.playersArray addObject:player2];
    }
}



- (void)initFishes
{
    
    if (self.fishArray==nil) {
        self.fishArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    if( self.fishSpawnPointsArray==nil )
    {
        self.fishSpawnPointsArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    for (int i =0; i< 5; i++) {
        
        SKSpriteNode* fishSprite = [SKSpriteNode spriteNodeWithImageNamed:@"greenfish.png"];
        fishSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fishSprite.size];
        fishSprite.physicsBody.categoryBitMask = GameColliderTypeFish;
        fishSprite.physicsBody.collisionBitMask = GameColliderTypeBoat;
        fishSprite.physicsBody.contactTestBitMask = GameColliderTypeBoat;
        fishSprite.physicsBody.dynamic = NO;
        fishSprite.position = ccp(-100, -100);
        fishSprite.hidden = YES;
        [self addChild:fishSprite];
        
        [self.fishArray addObject:fishSprite];

    }
    
    
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:screenCenterPoint()]];
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:ccp(620, 461)]];
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:ccp(558, 284)]];
    
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:ccp(115, 609)]];
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:ccp(102, 774)]];
    
    [_fishSpawnPointsArray addObject:[NSValue valueWithCGPoint:ccp(167, 486)]];

    
}

- (void)initRocks
{
    [self createRockAtLocation:ccp(NToVP_X(0.3f), NToVP_Y(0.3f)) scale:1.0f rotation:0];
    [self createRockAtLocation:ccp(NToVP_X(0.8f), NToVP_Y(0.7f)) scale:0.5f rotation:CC_DEGREES_TO_RADIANS(-90)];
    [self createRockAtLocation:screenCenterPoint() scale:0.5f rotation:CC_DEGREES_TO_RADIANS(-40)];
}

- (void)createRockAtLocation:(CGPoint)location scale:(float)scale rotation:(float)rotation
{
    
    SKSpriteNode* rock = [SKSpriteNode spriteNodeWithImageNamed:@"rock.png"];
    rock.position = location;
    [rock setScale:scale];
    
    SKSpriteNode* rock2 = [SKSpriteNode spriteNodeWithImageNamed:@"rock.png"];
    rock2.position = location;
    [rock2 setScale:scale];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -107.000 * scale, -57.000* scale);
    CGPathAddLineToPoint(path, NULL, -23.000* scale, -45.000* scale);
    CGPathAddLineToPoint(path, NULL, 84.000* scale, 29.000* scale);
    CGPathAddLineToPoint(path, NULL, 4.000* scale, 67.000* scale);
    CGPathAddLineToPoint(path, NULL, -96.000* scale, 56.000* scale);
    CGPathCloseSubpath(path);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 102.000* scale, -65.000* scale);
    CGPathAddLineToPoint(path2, NULL, 106.000* scale, -10.000* scale);
    CGPathAddLineToPoint(path2, NULL, 84.000* scale, 29.000* scale);
    CGPathAddLineToPoint(path2, NULL, -23.000* scale, -45.000* scale);
    CGPathAddLineToPoint(path2, NULL, 36.000* scale, -68.000* scale);
    CGPathCloseSubpath(path2);
    
    rock.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
    rock.physicsBody.dynamic = NO;
    rock.physicsBody.friction = 1.0f;
    rock.physicsBody.restitution = 0.01f;
    
    rock.physicsBody.categoryBitMask = GameColliderTypeWall;
    rock.physicsBody.collisionBitMask = GameColliderTypeBoat;
    rock.physicsBody.contactTestBitMask = GameColliderTypeBoat;
    
    rock2.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path2];
    rock2.physicsBody.dynamic = NO;
    rock2.physicsBody.categoryBitMask = GameColliderTypeWall;
    rock2.physicsBody.collisionBitMask = GameColliderTypeBoat;
    rock2.physicsBody.contactTestBitMask = GameColliderTypeBoat;
    rock2.physicsBody.friction = 1.0f;
    rock2.physicsBody.restitution = 0.01f;
    
    [self addChild:rock];
    [self addChild:rock2];
    
    rock.zRotation = rotation;
    rock2.zRotation = rotation;
    
    
    /*
    SKShapeNode* shapeNode = [[SKShapeNode alloc] init];
    shapeNode.path = path;
    shapeNode.strokeColor = [SKColor redColor];
    shapeNode.lineWidth = 0.4f;
    shapeNode.antialiased = YES;
    shapeNode.position = location;
    [self addChild:shapeNode];
    
    SKShapeNode* shapeNode2 = [[SKShapeNode alloc] init];
    shapeNode2.path = path2;
    shapeNode2.strokeColor = [SKColor redColor];
    shapeNode2.lineWidth = 0.4f;
    shapeNode2.antialiased = YES;
    shapeNode2.position = location;
    [self addChild:shapeNode2];*/
    
    CGPathRelease(path);
    CGPathRelease(path2);
}

#pragma mark - Reset Game

- (void)resetGame
{
    gameState = GameState_Start;
    
    //reset player
    player1.boat.position = ccp( NToVP_XF(0.5f), borderShapeNode.position.y + NToVP_YF(0.1f));
    player1.boat.zRotation = 0;
    player1.score = 0;
    [player1.boat reset];
    
    player2.boat.position = ccp( NToVP_XF(0.5f), NToVP_YF(1.0f) - (borderShapeNode.position.y + NToVP_YF(0.1f)) );
    player2.boat.zRotation = CC_DEGREES_TO_RADIANS(-180.f);
    player2.score = 0;
    [player2.boat reset];
    
    //reset fishes
    for (SKSpriteNode* fish in self.fishArray) {
        fish.hidden = YES;
    }
    
    [self spawnFish];
    [self spawnFish];
    [self updateScoreLabels];
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"location %f %f", location.x, location.y);
        
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
            
            if([player.gameButtonB.touch isEqual:touch])
            {
                NSLog(@"%@ touched gameButtonB 1", player.boat.name );
                break;
            }
            else
            {
                if([player.gameButtonB touchBegan:touch withTouchPosition:location])
                {
                    NSLog(@"%@ touched gameButtonB 2", player.boat.name );
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
            [player.gameButtonB touchEnd:touch withTouchPosition:CGPointZero];
        }
        
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
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
//    NSLog(@"didBeginContact");
    
    if( contact.bodyA && contact.bodyB && !contact.bodyA.node.hidden && !contact.bodyB.node.hidden)
    {
        if( contact.bodyA.categoryBitMask==GameColliderTypeBoat && contact.bodyB.categoryBitMask==GameColliderTypeFish )
        {
            [self playerCollidedWithFish:contact.bodyA withFish:contact.bodyB];
        }
        else if( contact.bodyB.categoryBitMask==GameColliderTypeBoat && contact.bodyA.categoryBitMask==GameColliderTypeFish )
        {
            [self playerCollidedWithFish:contact.bodyB withFish:contact.bodyA];
        }
    }
    
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
   // NSLog(@"didEndContact");
}

#pragma mark - Score Label

- (void)updateScoreLabels
{
    self.player1ScoreLabel.text = [NSString stringWithFormat:@"Player 1: %d", player1.score];
    self.player2ScoreLabel.text = [NSString stringWithFormat:@"Player 2: %d", player2.score];

}

#pragma mark - Fish

- (void)spawnFish
{
    NSUInteger idx = CCRANDOM_0_1() * _fishSpawnPointsArray.count;
    NSValue* point = [_fishSpawnPointsArray objectAtIndex:idx];
    [self spawnFishAtLocation:[point CGPointValue]];
}

- (void)spawnFishAtLocation:(CGPoint)location
{
    for (SKSpriteNode* fish in self.fishArray) {
        
        if(fish.hidden)
        {
            fish.hidden = NO;
            fish.position = ccpAdd(location, ccp(CCRANDOM_MINUS1_1()*NToVP_X(0.1f), CCRANDOM_MINUS1_1()*NToVP_X(0.1f)));
            
            
            break;
        }
    }
}

- (void)playerCollidedWithFish:(SKPhysicsBody*)player withFish:(SKPhysicsBody*)fish
{
    if([player isEqual:player1.boat.physicsBody])
    {
        player1.score+=10;
    }
    else if([player isEqual:player2.boat.physicsBody])
    {
        player2.score+=10;
    }
    
    fish.node.hidden = YES;
    
    [self spawnFish];
    [self updateScoreLabels];
}


@end
