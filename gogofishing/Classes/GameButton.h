//
//  GameButton.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameButton;

@protocol GameButtonDelegate <NSObject>

- (void)gameButtonOnPress:(GameButton*)gameButton;
- (void)gameButtonOnRelease:(GameButton*)gameButton;

@end

@interface GameButton : SKNode
{
    
}

@property (nonatomic, weak) UITouch*                    touch;
@property (nonatomic, assign) BOOL                      onTouch;
@property (nonatomic, strong) id <GameButtonDelegate>   delegate;
@property (nonatomic, assign) CGFloat                   buttoRadius;


- (id)initAtPosition:(CGPoint)position withLabel:(NSString*)label withRadius:(CGFloat)radius;
- (BOOL)touchBegan:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;
- (void)touchMove:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;
- (void)touchEnd:(UITouch*)touch withTouchPosition:(CGPoint)touchPosition;


@end
