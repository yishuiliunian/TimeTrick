//
//  DZTimeCell.h
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZTimeCell : UITableViewCell
@property (nonatomic, strong) DZTime* timer;
@property (nonatomic, strong) NSTimer* updateTimer;
@property (nonatomic, strong) UILabel* label;
@end
