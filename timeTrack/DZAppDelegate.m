//
//  DZAppDelegate.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-4.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZAppDelegate.h"
#import "DZTimesViewController.h"
#import "DZShakeWindow.h"
#import "PrettyNavigationBar.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "CloudReview.h"
#import "DZGuidViewController.h"

#import "DZIndexViewController.h"

static NSString* const ShareSDKKey = @"a670cbbfa8";
@implementation DZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WXApi registerApp:@"wx4e163efac64d5c2d"];
    
    [ShareSDK registerApp:ShareSDKKey];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"aa.sqlite"];
    self.window = [[DZShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    DZTimesViewController* viewController = [[DZTimesViewController alloc]init];
    UINavigationController* controller = [[UINavigationController alloc] initWithRootViewController:viewController];
    PrettyNavigationBar* prettyNav = [[PrettyNavigationBar alloc] init];
    
    [controller setValue:prettyNav forKey:@"navigationBar"];
//    self.window.rootViewController = controller;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController: [[DZIndexViewController alloc] init]];
    [self.window makeKeyAndVisible];
   //
    BOOL first = [[NSUserDefaults standardUserDefaults] boolForKey:@"notShowAgain"];
    if (!first) {
        DZGuidViewController* guidCon = [[DZGuidViewController alloc] init];
        UINavigationController* guidNav = [[UINavigationController alloc] initWithRootViewController:guidCon];
        [controller presentModalViewController:guidNav animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notShowAgain"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rateTheTimeTrack) userInfo:nil repeats:NO];
    return YES;
}
- (void) rateTheTimeTrack
{
    if ([CloudReview canRate]) {
        [[CloudReview sharedReview] reviewFor:607603885];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
