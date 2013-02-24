//
//  DZTimePickViewController.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-23.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DZTimePickViewDelegate <NSObject>
- (void) setBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
- (NSDate*) dateBegain;
- (NSDate*) dateEnd;
@end
@interface DZTimePickViewController : UIViewController
@property (nonatomic, assign) id<DZTimePickViewDelegate> delegate;
@end
