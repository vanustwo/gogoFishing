//
//  Joystick.m
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "Joystick.h"
#import "GameDefines.h"
#import "PhysicShapeBuilder.h"

@interface Joystick(Private)

- (CGPoint)stickPosition;
- (void)createJoystickRange;

@end

@implementation Joystick

- (id)initAtPosition:(CGPoint)position
{
    if( self=[super init] )
    {
        
        self.position = position;
        [self createJoystickRange];
        self.stick = [PhysicShapeBuilder addBallShapeNodeWithRadius:JOYSTICK_RADIUS withPhysicBody:NO];
        [self addChild:self.stick];
        
        
        
        [self resetStick];
    }
    
    return self;
    
}

- (void)createJoystickRange
{
    ShapeNode *shape = [[ShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, 0,0, JOYSTICK_MOVE_RADIUS, 0, M_PI*2, YES);
    shape.path = path;
    shape.strokeColor = [SKColor redColor];
    shape.antialiased = YES;
    shape.lineWidth = 1.0f;
    
    CGPathRelease(path);
    
    [self addChild:shape];
    

}

- (void)resetStick
{
    self.onTouch = NO;
    self.onDragged = NO;
    self.stick.position = CGPointZero;
    self.touchOffset = CGPointZero;
    self.deltaPosition = CGPointZero;
}

- (CGPoint)stickPosition
{
    return ccpAdd(self.position, self.stick.position);
}

- (BOOL)touchBegan:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    if( !_onTouch )
    {
        CGFloat distance = ccpDistance(touchPosition, [self stickPosition]);
        if( distance<JOYSTICK_RADIUS )
        {
            _onTouch = YES;
            _onDragged = NO;
            _touch = touch;
            _touchOffset = ccpSub(touchPosition, self.position);
            _deltaPosition = _touchOffset;
            NSLog(@"_touchOffset %f %f", _touchOffset.x, _touchOffset.y );
            
            return true;
        }
    }
    
    return false;
    
}

- (void)touchMove:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    if( _onTouch && [_touch isEqual:touch] )
    {
        _onDragged = YES;
        
        CGPoint stickOffset = ccpSub(touchPosition, self.position);
        
        CGFloat distance = ccpDistance(touchPosition, self.position);

        float touchAngle = ccpToAngle(stickOffset);
        _deltaPosition = stickOffset;
        
        if( distance<JOYSTICK_MOVE_RADIUS )
        {
            self.stick.position = ccpSub(stickOffset, _touchOffset);
        }
        else
        {
            //snap it on the edge
            CGPoint p = CGPointMake(self.position.x - (cosf(touchAngle) * JOYSTICK_MOVE_RADIUS), self.position.y - (sinf(touchAngle) * JOYSTICK_MOVE_RADIUS));
            p = ccpSub(self.position, p);
            self.stick.position = ccpSub(p, _touchOffset);
            
        }
        
    }
}

- (void)touchEnd:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition
{
    if( _onTouch && [_touch isEqual:touch] )
    {
        [self resetStick];
    }
}


- (void)update:(CFTimeInterval)currentTime
{
    
}

@end
