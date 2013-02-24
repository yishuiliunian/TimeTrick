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
    BOOL neverRate = NO;
    if(neverRate != YES) {  
        //Show alert here  
        UIAlertView *alert;  
       
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rate TimeTrack", nil)
                                           message:NSLocalizedString(@"If you feel this app good , please rate it in apple store. And let others use it.",nil)
                                          delegate: self  
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                 otherButtonTitles: NSLocalizedString(@"Rate now",nil), NSLocalizedString(@"Never show agian", nil) , nil];
        [alert show];  
    }  
}  
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{  
    if (buttonIndex == 1)  
    {  
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *str = [NSString stringWithFormat:  
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",  
                         m_appleID ];   
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];  
    }
    else
    {
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL) canRate
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"]) {
        return NO;
    }
    NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"i"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:i+1 forKey:@"i"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (i % 20 == 0 ) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end