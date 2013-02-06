//
//  DZPieViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-6.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZPieViewController.h"
#import "PieChartView.h"
@interface DZPieViewController ()
{
    PieChartView* timePieCharView;
}
@end

@implementation DZPieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timePieCharView = [[PieChartView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *valueArray = [[NSMutableArray alloc] initWithObjects:
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:3],
                                  [NSNumber numberWithInt:2],
                                  nil];
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithObjects:
                                  [UIColor blueColor],
                                  [UIColor redColor],
                                  [UIColor whiteColor],
                                  [UIColor greenColor],
                                  [UIColor purpleColor],
                                  nil];
    // 必须先创建一个相同大小的container view，再将PieChartView add上去
    timePieCharView.mValueArray = [NSMutableArray arrayWithArray:valueArray];
    timePieCharView.mColorArray = [NSMutableArray arrayWithArray:colorArray];
    timePieCharView.mInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 350, 300, 80)];
    timePieCharView.mInfoTextView.backgroundColor = [UIColor clearColor];
    timePieCharView.mInfoTextView.editable = NO;
    timePieCharView.mInfoTextView.userInteractionEnabled = NO;
    timePieCharView.frame = CGRectMake(0.0, 0.0, 320, 300);
    [self.view addSubview:timePieCharView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
