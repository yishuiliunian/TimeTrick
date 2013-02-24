//
//  DZSettings.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-22.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZSettings : NSObject
+ (id) shareInstance;
- (void) updateTimeTypes:(NSArray*)array;
- (NSArray*) allTimeTypes;
- (void) addTimeType:(NSString*)type;
@end
