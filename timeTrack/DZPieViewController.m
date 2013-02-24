//
//  DZPieViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-6.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZPieViewController.h"
#import "PCPieChart.h"
#import <ShareSDK/ShareSDK.h>
@interface DZPieViewController ()
{
    PCPieChart* timePieCharView;
}
@end


@implementation DZPieViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timePieCharView = [[PCPieChart alloc] init];
    }
    return self;
}
-(UIImage *) glToUIImage {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void) shareThisChart
{
    id publishContent = [ShareSDK publishContent:@"我在使用\"时间分析\"这个应用来追踪我的时间，快来看看吧。"
                                 defaultContent:@""
                                           image:[self glToUIImage]
                                   imageQuality:0.8
                                      mediaType:SSPublishContentMediaTypeNews
                                          title:@"ShareSDK"
                                            url:@"https://itunes.apple.com/us/app/shi-jian-fen-xi/id607603885?ls=1&mt=8"
                                   musicFileUrl:nil
                                        extInfo:nil
                                       fileData:nil];
    
    [ShareSDK showShareActionSheet:self
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                   oneKeyShareList:[NSArray defaultOneKeyShareList]
                    shareViewStyle:ShareViewStyleSimple
                    shareViewTitle:@"内容分享"
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                   
                                }
                                else if(state == SSPublishContentStateFail)
                                {
                                    NSLog(@"失败!");
                                }
                            }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setMoodBackgroud];
    float (^RandomColorFloat)(void)= ^{
        return (float)(random()%255/255.0);
    };
    UIBarButtonItem* shareItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(shareThisChart)];
    self.navigationItem.rightBarButtonItem = shareItem;
    NSFetchedResultsController* fetchController = [DZTime fetchAllGroupedBy:DZTimeType withPredicate:nil sortedBy:DZTimeDateBegain ascending:YES];
   
    int height = [self.view bounds].size.height - 30; // 220;
    int width = [self.view bounds].size.width; //320;
    timePieCharView.frame = CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height);
    [timePieCharView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [timePieCharView setDiameter:width/3*2];
    [timePieCharView setSameColorLabel:YES];
    [self.view addSubview:timePieCharView];
    
    NSMutableArray* components = [NSMutableArray arrayWithCapacity:5];
    for (id<NSFetchedResultsSectionInfo> sectionInfo in [fetchController sections]) {
        float sumSpace = 0.0;
        for (DZTime* each in [sectionInfo objects]) {
            float timeSpace = abs([each.dateBegain timeIntervalSinceDate:each.dateEnd]);
            if (timeSpace <0.0001) {
                timeSpace = 1;
            }
            sumSpace += timeSpace;
        }
        if (sumSpace > 0.0001) {
            PCPieComponent* compt = [PCPieComponent pieComponentWithTitle:NSLocalizedString([sectionInfo name],nil)  value:sumSpace];
            [compt setColour:[UIColor colorWithRed:RandomColorFloat() green:RandomColorFloat() blue:RandomColorFloat() alpha:1.0]];
            [components addObject:compt];
        }
    }
    [timePieCharView setComponents:components];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
