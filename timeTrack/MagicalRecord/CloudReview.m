//
//  CloudReview.m
//  Wiz
//
//  Created by wiz on 12-2-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CloudReview.h"

@implementation CloudReview  
static CloudReview* _sharedReview = nil;  
+(CloudReview*)sharedReview  
{  
    @synchronized([CloudReview class])  
    {  
        if (!_sharedReview)  
            _sharedReview = [[CloudReview alloc] init];
        
        return _sharedReview;  
    }  
}
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+(id)alloc
{  
    @synchronized([CloudReview class])
    {  
        NSAssert(_sharedReview == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedReview = [super alloc];  
        return _sharedReview;  
    }  
    
    return nil;  
}  
-(void)reviewFor:(int)appleID  
{  
    m_appleID = appleID;
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                     m_appleID ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  
    if (buttonIndex == 1)  
    {  
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];  
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",  
                         m_appleID ];   
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];  
    }  
}  
@end   