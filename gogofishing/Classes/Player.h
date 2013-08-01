//
//  Player.h
//  gogofishing
//
//  Created by Van on 01/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Boat;

@interface Player : NSObject
{
    
}

- (id)initPlayerAtPosition:(CGPoint)position;

@property(nonatomic,strong)Boat*        boat;


@end
