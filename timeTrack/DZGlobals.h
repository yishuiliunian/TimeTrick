//
//  DZGlobals.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-23.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrettyNavigationBar.h"
#define DZNavColor [UIColor colorWithR:217 g:203 b:191]
@interface DZGlobals : NSObject

@end
@interface UIView(Backgroud)
- (void) setMoodBackgroud;
@end
@interface PrettyNavigationBar (DZColor)
- (void) setDZColor;
@end