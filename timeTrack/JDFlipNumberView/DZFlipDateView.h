//
//  DZFlipDateView.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DZTimeTrackManager.h"
@interface DZFlipDateView : UIView
@property (nonatomic, strong, readonly) DZTimeTrackManager* timeTrackManager;
@property (nonatomic, strong) NSDate* beginDate;
@property (nonatomic, strong) NSDate* endDate;
- (void) startTrack;
- (void) stopTrack;
- (void) pasueTrack;
- (void) resumeTrack;
- (void) resetFlipViewDate:(NSDate*)beginDate toEnd:(NSDate*)endDate;
@end
