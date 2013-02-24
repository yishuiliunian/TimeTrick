//
//  DZTime.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-4.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTime.h"
#import "NSDate-Utilities.h"

NSString* const DZTimeDateBegain = @"dateBegain";
NSString* const DZTimeDateEnd = @"dateEnd";
NSString* const DZTimeDetail = @"detail";
NSString* const DZTimeType = @"type";
NSString* const DZTimeSectionInditify = @"sectionInditify";
@implementation DZTime

@dynamic dateBegain;
@dynamic dateEnd;
@dynamic detail;
@dynamic type;
@synthesize sectionInditify;

- (NSString*) sectionInditify
{
    NSDate* dateBegin = self.dateBegain;
    return [[NSString stringWithFormat:@"%d-%d-%d",[dateBegin year],[dateBegin month], [ dateBegin day]] lowercaseString];
}

@end
