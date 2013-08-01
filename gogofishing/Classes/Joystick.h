//
//  Joystick.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CGPointExtension.h"

@interface Joystick : SKNode
{
    
}


- (id)initAtPosition:(CGPoint)position;
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



@end
