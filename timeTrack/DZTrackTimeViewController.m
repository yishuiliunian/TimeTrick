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
#import "PrettyTableViewCell.h"
#import "DZSettings.h"
#import "DAKeyboardControl.h"
#import "PrettyToolbar.h"
#import "DZTimePickViewController.h"
#import "ToggleView.h"
#import "NSDate-Utilities.h"
@interface DZTrackTimeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, DZTimePickViewDelegate,ToggleViewDelegate>
{
    DZFlipDateView* dateFlipView;
    UIPickerView* pickView;
    UITextField* typeTextField;
    PrettyToolbar* typeToolBar;
    NSArray* timeKinds;
    ToggleView* toggleSwitchView;
}
@property (nonatomic, strong) DZTime* timeData;
@end

@implementation DZTrackTimeViewController
@synthesize timeData;
- (void) dealloc
{
    [self.view removeKeyboardControl];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    dateFlipView.beginDate= beginDate;
    dateFlipView.endDate = endDate;
    [toggleSwitchView setSelectedButton:ToggleButtonSelectedLeft];
}

- (NSDate*) dateBegain
{
    return dateFlipView.timeTrackManager.beginDate;
}

- (NSDate*) dateEnd
{
    return dateFlipView.timeTrackManager.endDate;
}
- (void) didGetShake:(NSNotification*)nc
{
    [dateFlipView stopTrack];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setBegainAndEndDate
{
    DZTimePickViewController* pickerDate = [[DZTimePickViewController alloc] init];
    pickerDate.delegate = self;
    [self.navigationController pushViewController:pickerDate animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        typeTextField = [[UITextField alloc] init];
        typeToolBar = [[PrettyToolbar alloc] init];
        typeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(addNewType) forControlEvents:UIControlEventTouchUpInside];
        [button dropShadowWithOpacity:0.01];
        button.frame = CGRectMake(0.0, 0.0, 40, 40);
        typeTextField.rightView = button;
        typeTextField.rightViewMode = UITextFieldViewModeAlways;
        typeTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [typeToolBar addSubview:typeTextField];
        dateFlipView = [[DZFlipDateView alloc] init];
        pickView = [[UIPickerView alloc] init];
        pickView.showsSelectionIndicator = YES;
    }
    return self;
}
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [timeKinds count]+1;
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetShake:) name:@"shake" object:nil];
}
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return NSLocalizedString(@"Add a new type", nil);
    }
    return [timeKinds objectAtIndex:row-1];
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [typeToolBar removeFromSuperview];
    if (row == 0) {
        typeToolBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(pickView.frame), 44);
        typeTextField.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(pickView.frame), 44 );
        [self.view addSubview:typeToolBar];
        [typeTextField becomeFirstResponder];
        [pickView selectRow:1 inComponent:0 animated:YES];
    }
}

- (void) addNewType
{
    NSString* type = [typeTextField text];
    if (type != nil) {
        [[DZSettings shareInstance] addTimeType:type];
    }
    [self reloadAllTypes];
    [typeTextField resignFirstResponder];
    for (int i = 0; i < [timeKinds count]; i++) {
        if ([type isEqualToString:[timeKinds objectAtIndex:i]]) {
            [pickView selectRow:i+1 inComponent:0 animated:YES];
            return;
        }
    }
}
- (void) reloadAllTypes
{
    timeKinds = [[DZSettings shareInstance] allTimeTypes];
    [pickView reloadAllComponents];
}
- (void) saveTime
{
    self.timeData = [DZTime createEntity];
    self.timeData.dateBegain = dateFlipView.timeTrackManager.beginDate;
    self.timeData.dateEnd = dateFlipView.endDate;
    if (self.timeData.dateEnd == nil) {
        self.timeData.dateEnd = [NSDate date];
    }
    if ([self.timeData.dateBegain isLaterThanDate:self.timeData.dateEnd]) {
        self.timeData.dateEnd = [NSDate dateWithTimeInterval:1 sinceDate:self.timeData.dateBegain];
    }
    self.timeData.type = [timeKinds objectAtIndex:[pickView selectedRowInComponent:0]-1];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [dateFlipView stopTrack];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.title = NSLocalizedString(@"Tracking...", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dz_backgroud"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTime)];
    //
    [self reloadAllTypes];
    float flipWidth = CGRectGetWidth(self.view.frame);
    dateFlipView.frame = CGRectMake(50, 20, flipWidth, 60);
    [self.view addSubview:dateFlipView];
  
    CGRect switchFrame =CGRectMake((CGRectGetWidth(self.view.frame)-128)/2, 80 + 20, 128, 50);
    toggleSwitchView = [[ToggleView alloc]initWithFrame:switchFrame toggleViewType:ToggleViewTypeNoLabel toggleBaseType:ToggleBaseTypeChangeImage toggleButtonType:ToggleButtonTypeChangeImage];
    toggleSwitchView.toggleDelegate = self;
    [self.view addSubview:toggleSwitchView];
    [dateFlipView startTrack];

    [toggleSwitchView setSelectedButton:ToggleButtonSelectedRight];
    //
    
    pickView.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-162, CGRectGetWidth(self.view.frame), 162);
    [self.view addSubview:pickView];
    pickView.delegate = self;
    [pickView selectRow:1 inComponent:0 animated:YES];
    
    self.view.keyboardTriggerOffset = self.view.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        PrettyToolbar* toolbar = typeToolBar;
        CGRect toolBarFrame = toolbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        typeToolBar.frame = toolBarFrame;
        if (self.view.frame.size.height - keyboardFrameInView.origin.y <= 0) {
            toolbar.hidden = YES;
        }
        else
        {
            toolbar.hidden = NO;
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Set date", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(setBegainAndEndDate)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) selectLeftButton
{
    [dateFlipView pasueTrack];
}
- (void) selectRightButton
{
    [dateFlipView resumeTrack];
}

@end
