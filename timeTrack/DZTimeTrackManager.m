//
//  DZTimeTrackManager.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTimeTrackManager.h"

static NSString* const DZTimeMangerBeginDate = @"DZTimeMangerBeginDate";
static NSString* const DZTimeMangerEndDate = @"DZTimeMangerEndDate";
static NSString* const DZTimeMangerPaused = @"DZTimeMangerPaused";
@implementation DZTimeTrackManager
- (void) startTimeTrack
{
    if ([DZTimeTrackManager isLastTrackFinished]) {
        [self setBeginDate:[NSDate date]];
    }
}

- (void) setBeginDate:(NSDate *)beginDate_
{
    [[NSUserDefaults standardUserDefaults] setObject:beginDate_ forKey:DZTimeMangerBeginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) setEndDate:(NSDate *)endDate_
{
    [[NSUserDefaults standardUserDefaults] setObject:endDate_  forKey:DZTimeMangerEndDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate*) endDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DZTimeMangerEndDate];
}
//- (void) pasueTimeTrack
//{
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DZTimeMangerPaused];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void) resumeTimeTrack
//{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DZTimeMangerPaused];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL) isPasued
//{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:DZTimeMangerPaused];
//}
- (void) stopTimeTrack
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DZTimeMangerBeginDate];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DZTimeMangerEndDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate*) beginDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DZTimeMangerBeginDate];
}

+ (BOOL) isLastTrackFinished
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DZTimeMangerBeginDate] == nil;
}

+ (NSDate*) lastTrackBeginDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DZTimeMangerBeginDate];
}

@end
