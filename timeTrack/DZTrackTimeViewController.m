//
//  DZTrackTimeViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTrackTimeViewController.h"
#import "DZFlipDateView.h"
#import "DZTimeTrackManager.h"

@interface DZTrackTimeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    DZFlipDateView* dateFlipView;
    UIPickerView* pickView;
    NSArray* timeKinds;
}
@end

@implementation DZTrackTimeViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didGetShake:(NSNotification*)nc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dateFlipView = [[DZFlipDateView alloc] init];
        pickView = [[UIPickerView alloc] init];
        timeKinds =  @[@"微博",@"写代码",@"在路上",@"吃饭",@"睡大觉"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetShake:) name:@"shake" object:nil];
        
    }
    
    return self;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [timeKinds count];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [dateFlipView stopTrack];
    DZTime* time = [DZTime createEntity];
    time.dateBegain = dateFlipView.timeTrackManager.beginDate;
    time.dateEnd = dateFlipView.timeTrackManager.endDate;
    time.type = [timeKinds objectAtIndex:[pickView selectedRowInComponent:0]];
    [[NSManagedObjectContext defaultContext] saveOnlySelfAndWait];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [timeKinds objectAtIndex:row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateFlipView.frame = CGRectMake(0.0, 0.0, 320, 40);
    [self.view addSubview:dateFlipView];
    
    [dateFlipView startTrack];
    pickView.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-200, CGRectGetWidth(self.view.frame), 100);
    [self.view addSubview:pickView];
    pickView.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
