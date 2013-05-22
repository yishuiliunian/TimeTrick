//
//  DZTitleView.h
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DZTitleViewPositionLeft = 1,
    DZTitleViewPositionRight = 2
}DZTitleViewPosition;

typedef struct {
    float titleLength;
    DZTitleViewPosition postion;
    
} DZTitleViewLayout;


@interface DZTitleView : UIView
@property (nonatomic, strong) UILabel* titleTextLabel;
@property (nonatomic, strong) UILabel* detailTextLable;
@property (nonatomic, assign) DZTitleViewLayout layout;

- (id) initWithLayout:(DZTitleViewLayout)layout;

@end
