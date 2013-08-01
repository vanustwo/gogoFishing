//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "BaseView.h"

#define kMinTimeInterval (1.0f / 60.0f)

@implementation BaseView

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        
    }
    return self;
}

- (int)NToVP_X:(float)dist
{
    return (int)(dist * self.frame.size.width);
}

- (float)NToVP_XF:(float)dist
{
    return (dist * self.frame.size.width);
}

- (int)NToVP_Y:(float)dist
{
    return (int)(dist * self.frame.size.height);
}

- (float)NToVP_YF:(float)dist
{
   return (dist * self.frame.size.height);
}

- (CGPoint)screenCenterPoint
{
    return CGPointMake(CGRectGetMidX(self.frame),
                CGRectGetMidY(self.frame));
}


-(void)update:(CFTimeInterval)currentTime {
    self.timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.timeSinceLast = MIN(self.timeSinceLast, kMinTimeInterval);
    
    self.lastUpdateTimeInterval = currentTime;
    
    
}

@end
