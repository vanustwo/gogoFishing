//
//  GameButton.m
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameButton.h"
#import "ShapeNode.h"
#import "CGPointExtension.h"

@implementation GameButton

- (id)initAtPosition:(CGPoint)position
{
    if( self=[super init] )
    {
        self.position = position;
        [self createButtonAtPosition];
    }
    
    return self;
    
}

- (void)createButtonAtPosition
{
    ShapeNode *shape = [[ShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, 0,0, GAME_BUTTON_RADIUS, 0, M_PI*2, YES);
    shape.path = path;
    shape.fillColor = [SKColor greenColor];
    shape.strokeColor = [SKColor greenColor];
    shape.antialiased = YES;
    shape.lineWidth = 1.0f;
    
    CGPathRelease(path);
    
    [self addChild:shape];
    
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontSize:20];
    [label setFontColor:[SKColor blackColor]];
    [label setText:@"A"];
    [self addChild:label];
    
    
    _touch = nil;
    _onTouch = false;
    
}

- (BOOL)touchBegan:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    if( !_onTouch )
    {
        CGFloat distance = ccpDistance(touchPosition, self.position);
        if( distance<GAME_BUTTON_RADIUS )
        {
            _onTouch = YES;
            _touch = touch;
            NSLog(@"_touchOffset");
            
            if( [_delegate respondsToSelector:@selector(gameButtonOnPress:)] )
            {
                [_delegate gameButtonOnPress:self];
            }
            
            
            return true;
        }
    }
    
    return false;
}

- (void)touchMove:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    
}

- (void)touchEnd:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    if( _onTouch && [_touch isEqual:touch] )
    {
        _onTouch = NO;
        _touch = nil;
        
        if( [_delegate respondsToSelector:@selector(gameButtonOnRelease:)] )
        {
            [_delegate gameButtonOnRelease:self];
        }
    }
}



@end
