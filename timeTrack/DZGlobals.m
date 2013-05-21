//
//  DZGlobals.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-23.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZGlobals.h"

@implementation UIView(Backgroud)

- (void) setMoodBackgroud
{
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dz_backgroud"]];
}

@end
@implementation DZGlobals

@end

@implementation PrettyNavigationBar(DZColor)
- (void) setDZColor
{
    self.gradientStartColor = [UIColor colorWithR:217 g:203 b:191];
    self.gradientEndColor = [UIColor colorWithR:217 g:203 b:191];
}
@end