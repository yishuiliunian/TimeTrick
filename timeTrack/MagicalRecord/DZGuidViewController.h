//
//  DZGuidViewController.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-24.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DZGuidViewDelegate
- (NSInteger) numberOfImages;
- (UIImage*) imageForIndex:(NSInteger)index;
@end
@interface DZGuidViewController : UIViewController
@property (nonatomic, assign) id<DZGuidViewDelegate> delegate;
@end
