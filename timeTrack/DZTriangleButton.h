//
//  DZTriangleButton.h
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DZTriangleButtonDirectionUp,
    DZTriangleButtonDirectionDown
}DZTriangleButtonDirection;

@interface DZTriangleButton : UIControl
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, assign) DZTriangleButtonDirection triangleDirection;
@end
