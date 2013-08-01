//
//  MouseJoint.h
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MouseJoint : NSObject

@property (nonatomic, strong) SKPhysicsJointLimit*  mouseJoint;
@property (nonatomic, strong) SKNode*               mouseNode;
@property (nonatomic, assign) UITouch*              touch;
@property (nonatomic, assign) CGPoint               currentPosition;
@property (nonatomic, strong) SKScene*              scene;
@property (nonatomic, weak)   SKNode*               dragNode;


- (void)createMouseNodeAtPoint:(CGPoint)point withNode:(SKNode *)node inScene:(SKScene*)scene withTouch:(UITouch*)touch;
- (void)destroyMouseJoint;

@end
