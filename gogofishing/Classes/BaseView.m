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

-(void)update:(CFTimeInterval)currentTime {
    self.timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.timeSinceLast = MIN(self.timeSinceLast, kMinTimeInterval);
    
    self.lastUpdateTimeInterval = currentTime;
    
    
}

@end
