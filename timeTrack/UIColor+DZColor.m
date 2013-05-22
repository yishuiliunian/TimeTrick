//
//  UIColor+DZColor.m
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "UIColor+DZColor.h"

#define UIColorStaticWithHex(hex) static UIColor* color = nil;\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
color = [UIColor colorWithHex:hex];\
});\
return color;

@implementation UIColor (DZColor)

+ (UIColor*) themeBackgroupColor
{
    UIColorStaticWithHex(0x454343);
}

+ (UIColor*) themeTitleColor
{
    UIColorStaticWithHex(0x9ac449);
}

+ (UIColor*) themeDetailColor
{
    UIColorStaticWithHex(0xbfdea1);
}

+ (UIColor*) themeSandColor
{
    UIColorStaticWithHex(0x9ac449);
}

+ (UIColor*) themeSandHighlightColor
{
    UIColorStaticWithHex(0x454343);
}

@end
