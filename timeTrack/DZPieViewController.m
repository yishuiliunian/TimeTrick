//
//  DZPieViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-6.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZPieViewController.h"
#import "PCPieChart.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    float (^RandomColorFloat)(void)= ^{
        return (float)(random()%255/255.0);
    };
    
    NSFetchedResultsController* fetchController = [DZTime fetchAllGroupedBy:DZTimeType withPredicate:nil sortedBy:nil ascending:YES];
   
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    timePieCharView.frame = CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height);
    [timePieCharView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [timePieCharView setDiameter:width/2];
    [timePieCharView setSameColorLabel:YES];
    [self.view addSubview:timePieCharView];
    
    NSMutableArray* components = [NSMutableArray arrayWithCapacity:5];
    for (id<NSFetchedResultsSectionInfo> sectionInfo in [fetchController sections]) {
        float sumSpace = 0.0;
        for (DZTime* each in [sectionInfo objects]) {
            float timeSpace = abs([each.dateBegain timeIntervalSinceDate:each.dateEnd]);
            sumSpace += timeSpace;
        }
        if (sumSpace > 0.0) {
            PCPieComponent* compt = [PCPieComponent pieComponentWithTitle:[sectionInfo name]  value:sumSpace];
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
