//
//  DZNumberView.m
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//


#import "DZNumberView.h"

@interface DZNumberView ()
{
    NSMutableArray* componentArray;
}
@end

@implementation DZNumberView
@synthesize number = _number;
- (void) commitInit
{
    componentArray = [NSMutableArray new];
    for (int i = 0; i < 8; ++i) {
        UIView* aView = [[UIView alloc] init];
        aView.backgroundColor = [UIColor redColor];
        [self addSubview:aView];
        [componentArray addObject:aView];
        
        _number = 0;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commitInit];
    }
    return self;
}
- (void) setNumber:(int)number
{
    _number = number % 10;
    [self setNeedsLayout];
}
- (NSArray*) rectArray:(int)number
{
    switch (number) {
        case 0:
            return [self zero];
        case 1:
            return [self one];
        case 2:
            return [self two];
        case 3:
            return [self three];
        case 4:
            return [self four];
        case 5:
            return [self five];
        case 6:
            return [self six];
        case 7:
            return [self seven];
        case 8:
            return [self eight];
        case 9:
            return [self  nine];
        default:
            return [self zero];
            break;
    }
    return [self zero];
}

- (void) layoutSubviews
{
    
    NSArray* rectArray = [self rectArray:_number];
    int count = [rectArray count];
    for (int i = 0; i < 8; ++i) {
        UIView* aView = [componentArray objectAtIndex:i];
        if (i < count) {
            CGRect rect;
            CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)(rectArray[i]), &rect);
            [UIView animateWithDuration:0.2 animations:^{
                aView.frame = rect;
            }];
        }
        else
        {
            aView.frame = CGRectZero;
        }
    }

}
- (NSArray*) zero
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds))))];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetMaxX(self.bounds) -3, 0, 3, CGRectGetHeight(self.bounds))))];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    return array;
}
- (NSArray*) one
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds))))];
    return array;
}
- (NSArray*) eight
{
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetMaxX(self.bounds) -3, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    return array;}

- (NSArray*) five
{
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetWidth(self.bounds)-3, CGRectGetHeight(self.bounds)/2, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    
    return array;
 
}
- (NSArray*) two
{
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
     [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetMaxX(self.bounds) -3, 0, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
   //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, 3, CGRectGetHeight(self.bounds)/2)))];
   //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    
    return array;
}

- (NSArray*) three
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetWidth(self.bounds) - 3, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    return array;
}

- (NSArray*) four
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetWidth(self.bounds) - 3, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    return array;
}
- (NSArray*) six
{
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
       [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetMaxX(self.bounds) -3, CGRectGetHeight(self.bounds)/2, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    return array;
}

- (NSArray*) seven
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetWidth(self.bounds) - 3, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    return array;
}
- (NSArray*) nine
{
    NSMutableArray* array = [NSMutableArray new];
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 3, CGRectGetHeight(self.bounds)/2)))];
    //
    
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(0, CGRectGetHeight(self.bounds)-3, CGRectGetWidth(self.bounds), 3)))];
    //
    [array addObject:(__bridge id)(CGRectCreateDictionaryRepresentation(CGRectMake(CGRectGetMaxX(self.bounds) -3, 0, 3, CGRectGetHeight(self.bounds))))];
    //
    return array;
}

@end
