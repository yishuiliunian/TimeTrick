//
//  DZFlipDateView.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZFlipDateView.h"
#import "JDGroupedFlipNumberView.h"
#import "NSDate-Utilities.h"
typedef enum {
    DZFlipDateViewDay = 1000,
    DZFlipDateViewHour,
    DZFlipDateViewMinutes,
    DZFlipDateViewSecond,
}DZFlipDateViewTag;

@interface DZFlipDateView () <JDGroupedFlipNumberViewDelegate>
{
    NSArray* flipDataViewArray;
    float timeDuration;
}
@property (nonatomic, strong) NSDate* trackBeginTime;
@end
@implementation DZFlipDateView
@synthesize beginDate;
@synthesize endDate;
@synthesize timeTrackManager = _timeTrackManager;
@synthesize trackBeginTime = _trackBeginTime;
- (void) setZDistance:(NSUInteger)zDistance
{
    for (UIView* each in [self subviews]) {
        if ([each isKindOfClass:[JDGroupedFlipNumberView class]]) {
            JDGroupedFlipNumberView* jdg = (JDGroupedFlipNumberView*)each;
            [jdg setZDistance:zDistance];
        }
    }
}

- (void) setBeginDate:(NSDate *)beginDate_
{
    beginDate = beginDate_;
    self.timeTrackManager.beginDate = beginDate_;
}

- (void) setFrame:(CGRect)frame
{
    CGFloat digitWidth = CGRectGetWidth(frame)/5;
    CGFloat margin = digitWidth/([flipDataViewArray count]+1);
    for (int i = 0; i < [flipDataViewArray count]; ++i) {
        JDGroupedFlipNumberView* groupView = [flipDataViewArray objectAtIndex:i];
        if (i>0) {
            JDGroupedFlipNumberView* preView =[flipDataViewArray objectAtIndex:i-1];
            groupView.frame = CGRectOffset(preView.frame, CGRectGetWidth(preView.frame)+ margin, 0);
        }
        else
        {
            groupView.frame = CGRectMake(margin, CGRectGetMinY(frame), digitWidth, CGRectGetHeight(frame));
        }
    }
    
}
- (id) init
{
    self = [super init];
    if (self) {
        NSMutableArray* flips = [NSMutableArray arrayWithCapacity:4];
        _timeTrackManager = [[DZTimeTrackManager alloc] init];
        for (int i = 0 ; i < 4 ; i++) {
            JDGroupedFlipNumberView* groupFlip = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount:2];
            groupFlip.delegate = self;
            groupFlip.tag = 1000+i;
            groupFlip.currentDirection = eFlipDirectionUp;
            if (i == DZFlipDateViewHour%1000) {
                groupFlip.maximumValue = 23;
            }
            else
            {
                groupFlip.maximumValue = 59;
            }
            [groupFlip setZDistance:60];
            [flips addObject:groupFlip];
            [self addSubview:groupFlip];
        }
        flipDataViewArray = flips;
        
    }
    return self;
}
- (void) startTrack
{
    NSDate* timerTrackBD = [_timeTrackManager beginDate];
    NSDate* timerTrackED = [_timeTrackManager endDate];
    beginDate = timerTrackBD?timerTrackBD:[NSDate date];
    self.trackBeginTime = beginDate;
    timeDuration = 0;
    endDate = timerTrackED?timerTrackED:[NSDate date];
   [[flipDataViewArray objectAtIndex:DZFlipDateViewSecond%1000] animateUpWithTimeInterval:1];
    [_timeTrackManager startTimeTrack];
    [self resetFlipViewDate:beginDate toEnd:endDate];
}

- (void) stopTrack
{
    [[flipDataViewArray objectAtIndex:DZFlipDateViewSecond%1000] stopAnimation];
    [_timeTrackManager stopTimeTrack];
}

NSUInteger (^flipCurrentNumber)(NSArray*,DZFlipDateViewTag) = ^(NSArray* array, DZFlipDateViewTag tag)
{
    return (NSUInteger)[[array objectAtIndex:tag%1000] intValue];
};

- (CGFloat) totalTimeInterval
{
    NSInteger second = flipCurrentNumber(flipDataViewArray, DZFlipDateViewSecond);
    NSInteger m = flipCurrentNumber(flipDataViewArray,DZFlipDateViewMinutes);
    NSInteger h = flipCurrentNumber(flipDataViewArray, DZFlipDateViewHour);
    NSInteger d = flipCurrentNumber(flipDataViewArray, DZFlipDateViewDay);
    return d*24*60*60 + h*60*60 + m*60 + second;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
    }
    return self;
}
- (BOOL) checkTimeIsRight
{
    if (abs([self totalTimeInterval] - abs([self.timeTrackManager.beginDate timeIntervalSinceDate:self.timeTrackManager.beginDate])) > 1.0) {
        return false;
    }
    else
    {
        return YES;
    }
}

- (JDGroupedFlipNumberView*) jdGroupFlipViewByTag:(DZFlipDateViewTag)tag
{
    return [flipDataViewArray objectAtIndex:tag%1000];
}

- (void) resetFlipViewDate:(NSDate*)beginDate_ toEnd:(NSDate*)endDate_
{
    beginDate = beginDate_;
    endDate = endDate_;
     _trackBeginTime = [NSDate date];
    timeDuration = 0;
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate:beginDate toDate:endDate  options: 0];
    [self jdGroupFlipViewByTag:DZFlipDateViewDay].intValue  = [dateComponents day];
    [self jdGroupFlipViewByTag:DZFlipDateViewHour].intValue   = [dateComponents hour];
    [self jdGroupFlipViewByTag:DZFlipDateViewMinutes].intValue = [dateComponents minute];
    [self jdGroupFlipViewByTag:DZFlipDateViewSecond].intValue = [dateComponents second];
}
- (void) pasueTrack
{
    [[flipDataViewArray objectAtIndex:DZFlipDateViewSecond%1000] stopAnimation];
}
- (void) resumeTrack
{
    [self resetFlipViewDate:self.beginDate toEnd:self.endDate];
   [[flipDataViewArray objectAtIndex:DZFlipDateViewSecond%1000] animateUpWithTimeInterval:1];
}
- (void) groupedFlipNumberView:(JDGroupedFlipNumberView *)groupedFlipNumberView willChangeToValue:(NSUInteger)newValue
{
    timeDuration += 1;
    NSLog(@"interval %f",fabs(fabs([_trackBeginTime timeIntervalSinceNow]) - timeDuration));
    if (fabs(fabs([_trackBeginTime timeIntervalSinceNow]) - timeDuration) > 1) {
        if (!self.endDate) {
            [self resetFlipViewDate:beginDate toEnd:[NSDate date]];
        }
        else
        {
            [self resetFlipViewDate:beginDate toEnd:[NSDate dateWithTimeInterval:fabs([_trackBeginTime timeIntervalSinceNow]) sinceDate:self.endDate]];
        }
    }
    endDate = [NSDate dateWithTimeInterval:1 sinceDate:endDate];
    JDGroupedFlipNumberView* animateView = nil;
    if (groupedFlipNumberView.tag == DZFlipDateViewSecond) {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewMinutes%1000];
    }
    else if (groupedFlipNumberView.tag == DZFlipDateViewMinutes)
    {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewHour%1000];
    }
    else if (groupedFlipNumberView.tag == DZFlipDateViewHour)
    {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewDay%1000];
    }
    if (animateView) {
        if (newValue == 0 && groupedFlipNumberView.intValue == groupedFlipNumberView.maximumValue) {
            [animateView animateToNextNumber];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
