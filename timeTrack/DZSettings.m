//
//  DZSettings.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-22.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZSettings.h"
static NSString* const DZTimeTypes = @"DZTimeTypes";
@implementation DZSettings
+ (id) shareInstance
{
    static DZSettings* settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[DZSettings alloc] init];
    });
    return settings;
}
- (id) copy
{
    return [DZSettings shareInstance];
}

- (void) updateTimeTypes:(NSArray*)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:DZTimeTypes];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*) allTimeTypes
{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:DZTimeTypes];
    if (array == nil) {
        array = @[@"睡大觉",
                 @"吃饭"
                 ,@"工作"
                 ,@"看微博"];
        [self updateTimeTypes:array];
    }
    return array;
}

- (void) addTimeType:(NSString*)type
{
    NSArray* array = [self allTimeTypes];
    for (NSString* each in array) {
        if ([each isEqualToString:type]) {
            return;
        }
    }
    NSMutableArray* arrayM = [array mutableCopy];
    [arrayM addObject:type];
    [self updateTimeTypes:arrayM];
}
@end
