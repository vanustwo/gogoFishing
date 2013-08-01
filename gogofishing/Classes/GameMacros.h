//
//  GameMacros.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#ifndef Yoga_GameMacros_h
#define Yoga_GameMacros_h


// Some Cocos2d helper macros

/** @def CCRANDOM_MINUS1_1
 returns a random float between -1 and 1
 */
#define CCRANDOM_MINUS1_1() ((random() / (float)0x3fffffff )-1.0f)

/** @def CCRANDOM_0_1
 returns a random float between 0 and 1
 */
#define CCRANDOM_0_1() ((random() / (float)0x7fffffff ))

/** @def CC_DEGREES_TO_RADIANS
 converts degrees to radians
 */
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180

/** @def CC_RADIANS_TO_DEGREES
 converts radians to degrees
 */
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

#define ALL_COLLISION_BITS      0xffff

#define LIMBS_GRAB_RADIUS       6


static inline float lerpf(float a, float b, float t)
{
    return a * (1.f - t) + b * t;
}




#endif
