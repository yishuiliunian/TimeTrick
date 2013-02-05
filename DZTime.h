//
//  DZTime.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-4.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DZTime : NSManagedObject

@property (nonatomic, retain) NSDate * dateBegain;
@property (nonatomic, retain) NSDate * dateEnd;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * type;

@end
