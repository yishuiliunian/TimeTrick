//
//  DZTriangleButton.m
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTriangleButton.h"
#import "UIColor+DZColor.h"

@implementation DZTriangleButton
@synthesize triangleDirection = _triangleDirection;
@synthesize titleLabel = _titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        // Initialization code
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (_triangleDirection == DZTriangleButtonDirectionUp) {
        _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 40, CGRectGetWidth(self.bounds), 40);
    }
    else
    {
        _titleLabel.frame = CGRectMake(0, 0 , CGRectGetWidth(self.bounds), 30);
    }
    
}
- (void)drawRect:(CGRect)rect
{
    if (!self.highlighted) {
        [[UIColor themeSandColor] set];
        [[UIColor blackColor] setStroke];
    }
    else
    {
        [[UIColor themeSandHighlightColor] set];
        [[UIColor whiteColor] setStroke];
    }
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:3];
    if (_triangleDirection == DZTriangleButtonDirectionDown) {
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect)/2, CGRectGetMaxY(rect))];
        [bezierPath closePath];
    }
    else {
        [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect)/2, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, CGRectGetHeight(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [bezierPath closePath];
    }
    
    [bezierPath fill];
    [bezierPath stroke];
    
}

@end
