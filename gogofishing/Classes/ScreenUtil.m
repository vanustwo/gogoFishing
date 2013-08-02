//
//  ScreenUtil.m
//  gogofishing
//
//  Created by Van on 02/08/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "ScreenUtil.h"

int NToVP_X(float dist)
{
    return (int)(dist * [[UIScreen mainScreen] bounds].size.width);
}

float NToVP_XF(float dist)
{
    return (dist * [[UIScreen mainScreen] bounds].size.width);
}

int NToVP_Y(float dist)
{
    return (int)(dist * [[UIScreen mainScreen] bounds].size.height);
}

float NToVP_YF(float dist)
{
    return (dist * [[UIScreen mainScreen] bounds].size.height);
}


CGPoint screenCenterPoint()
{
    return CGPointMake(NToVP_XF(0.5f), NToVP_YF(0.5f));
}
