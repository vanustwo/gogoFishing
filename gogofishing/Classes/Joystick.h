//
//  Joystick.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CGPointExtension.h"
#import "GameDefines.h"

@class Joystick;

@protocol JoystickDelegate <NSObject>

- (void)joystickDidMove:(Joystick*)joystick withDeltaPosition:(CGPoint)position;

@end

@interface Joystick : SKNode
{
    
}


- (id)initAtPosition:(CGPoint)position joystickRadius:(CGFloat)joystickRadius joystickMoveRadius:(CGFloat)joystickMoveRadius;
- (void)resetStick;
- (void)update:(CFTimeInterval)currentTime;
- (BOOL)touchBegan:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;
- (void)touchMove:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;
- (void)touchEnd:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;

@property (nonatomic, strong) SKNode*  stick;
@property (nonatomic, strong) SKNode*  accelerateButton;
@property (nonatomic, weak) UITouch*   touch;
@property (nonatomic, assign) BOOL     onTouch;
@property (nonatomic, assign) BOOL     onDragged;
@property (nonatomic, assign) CGPoint  touchOffset;
@property (nonatomic, assign) CGPoint  deltaPosition;
@property (nonatomic, assign) CGFloat  joystickRadius;
@property (nonatomic, assign) CGFloat  joystickMoveRadius;
@property (nonatomic, assign) Joystick_Position joystickPosition;

@property (nonatomic, strong) id <JoystickDelegate> delegate;


@end
