//
//  DZTimeTrackManager.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZTimeTrackManager : NSObject
@property (nonatomic, strong, readonly) NSDate* beginDate;
@property (nonatomic, strong, readonly) NSDate* endDate;
- (void) startTimeTrack;
- (void) stopTimeTrack;
+ (BOOL) isLastTrackFinished;
+ (NSDate*) lastTrackBeginDate;
@end
