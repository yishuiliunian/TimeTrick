//
//  DZTitleView.m
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTitleView.h"



@interface DZTitleView ()
{
    
}

@end

@implementation DZTitleView

@synthesize titleTextLabel = _titleTextLabel;
@synthesize detailTextLable = _detailTextLable;
@synthesize layout = _layout;


- (UILabel*) aLabel
{
    UILabel* label = [[UILabel alloc] init];
    [self addSubview:label];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void) commitInit
{
    _titleTextLabel = [self aLabel];
    _detailTextLable = [self aLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}




- (id) initWithLayout:(DZTitleViewLayout )layout
{
    self = [super init];
    if (self) {
        _layout = layout;
        [self commitInit];
    }
    return self;
}

- (void) layoutSubviews
{
    if (_layout.postion == DZTitleViewPositionLeft) {
        _titleTextLabel.frame = CGRectMake(0, 0, _layout.titleLength, CGRectGetHeight(self.bounds));
        _detailTextLable.frame = CGRectMake(CGRectGetMaxX(_titleTextLabel.frame), 0, CGRectGetWidth(self.bounds) - CGRectGetWidth(_titleTextLabel.frame), CGRectGetHeight(self.bounds));
    }
    else if (_layout.postion == DZTitleViewPositionRight)
    {
        _detailTextLable.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - _layout.titleLength, CGRectGetHeight(self.bounds));
        _titleTextLabel.frame = CGRectMake(CGRectGetMaxX(_detailTextLable.frame), 0, _layout.titleLength, CGRectGetHeight(self.bounds));
    }
}
@end
