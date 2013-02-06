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
}
@end
@implementation DZFlipDateView
@synthesize timeTrackManager = _timeTrackManager;
- (void) setZDistance:(NSUInteger)zDistance
{
    for (UIView* each in [self subviews]) {
        if ([each isKindOfClass:[JDGroupedFlipNumberView class]]) {
            JDGroupedFlipNumberView* jdg = (JDGroupedFlipNumberView*)each;
            [jdg setZDistance:zDistance];
        }
    }
}


- (void) setFrame:(CGRect)frame
{
    CGFloat digitWidth = CGRectGetWidth(frame)/5;
    CGFloat margin = digitWidth/6;
    for (int i = 0; i < [flipDataViewArray count]; ++i) {
        JDGroupedFlipNumberView* groupView = [flipDataViewArray objectAtIndex:i];
        if (i>0) {
            JDGroupedFlipNumberView* preView =[flipDataViewArray objectAtIndex:i-1];
            groupView.frame = CGRectOffset(preView.frame, CGRectGetWidth(preView.frame)+ margin, 0);
        }
        else
        {
            groupView.frame = CGRectMake(0.0, 0.0, digitWidth, 60);
        }
    }
    
}
- (id) init
{
    self = [super init];
    if (self) {
        NSMutableArray* flips = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0 ; i < 4 ; i++) {
            _timeTrackManager = [[DZTimeTrackManager alloc] init];
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

   [[flipDataViewArray objectAtIndex:DZFlipDateViewSecond%1000] animateUpWithTimeInterval:1];
    [_timeTrackManager startTimeTrack];
    [self resetFlipViewDate];
}

- (void) stopTrack
{
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
    NSLog(@"%f   %f   %f",[self totalTimeInterval], [self.timeTrackManager.beginDate timeIntervalSinceDate:[NSDate date]],[self totalTimeInterval] - [self.timeTrackManager.beginDate timeIntervalSinceDate:[NSDate date]]);
    if (abs([self totalTimeInterval] - abs([self.timeTrackManager.beginDate timeIntervalSinceDate:[NSDate date]])) > 1.0) {
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

- (void) resetFlipViewDate
{
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate:self.timeTrackManager.beginDate toDate:[NSDate date]  options: 0];
    [self jdGroupFlipViewByTag:DZFlipDateViewDay].intValue  = [dateComponents day];
    [self jdGroupFlipViewByTag:DZFlipDateViewHour].intValue   = [dateComponents hour];
    [self jdGroupFlipViewByTag:DZFlipDateViewMinutes].intValue = [dateComponents minute];
    [self jdGroupFlipViewByTag:DZFlipDateViewSecond].intValue = [dateComponents second];
}

- (void) groupedFlipNumberView:(JDGroupedFlipNumberView *)groupedFlipNumberView willChangeToValue:(NSUInteger)newValue
{
    if (![self checkTimeIsRight]) {
        [self resetFlipViewDate];
    }
    JDGroupedFlipNumberView* animateView = nil;
    if (groupedFlipNumberView.tag == DZFlipDateViewSecond) {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewMinutes%1000];
    }
    else if (groupedFlipNumberView.tag == DZFlipDateViewMinutes)
    {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewHour%1000];
    }
    else if (groupedFlipNumberView.tag = DZFlipDateViewHour)
    {
        animateView = [flipDataViewArray objectAtIndex:DZFlipDateViewDay%1000];
    }
    if (animateView) {
        if (newValue == groupedFlipNumberView.maximumValue) {
            [animateView animateToNextNumber];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
