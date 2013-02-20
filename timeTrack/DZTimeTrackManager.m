//
//  DZTimeTrackManager.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTimeTrackManager.h"

@implementation DZTimeTrackManager
@synthesize beginDate=_beginDate;
@synthesize endDate=_endDate;

- (void) startTimeTrack
{
    if (![DZTimeTrackManager isLastTrackFinished]) {
        _beginDate = [DZTimeTrackManager lastTrackBeginDate];
    }
    else
    {
        _beginDate = [NSDate date];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_beginDate forKey:@"beginDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) stopTimeTrack
{
    _endDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beginDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isLastTrackFinished
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"beginDate"] == nil;
}

+ (NSDate*) lastTrackBeginDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"beginDate"];
}

@end
