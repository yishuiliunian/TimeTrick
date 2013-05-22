//
//  DZTimePickViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-23.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTimePickViewController.h"
#import "NSDate-Utilities.h"
static float const DZPickerCellHeight = 160;
@interface DZTimePickViewController ()
{
    UIDatePicker* dateBeginPicker;
    UIDatePicker* dateEndPicker;
}
@end

@implementation DZTimePickViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dateBeginPicker = [[UIDatePicker alloc] init];
        [dateBeginPicker addTarget:self action:@selector(beginDateChanged:) forControlEvents:UIControlEventValueChanged];
        
        dateEndPicker = [[UIDatePicker alloc] init];
        [dateEndPicker addTarget:self action:@selector(endDateChanged:) forControlEvents:UIControlEventValueChanged];

        // Custom initialization
    }
    return self;
}
- (void) beginDateChanged:(id)sender
{
    [dateEndPicker setMinimumDate:[sender date]];
}

- (void) endDateChanged:(id)sender
{
    NSDate* endDate = [sender date];
    if ([endDate isEarlierThanDate:[sender minimumDate]]) {
        [sender setDate:[sender minimumDate] animated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    void (^decratorLabel)(UILabel*)= ^(UILabel*label)
    {
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textAlignment = UITextAlignmentCenter;
    };
    //
    self.view.backgroundColor = [UIColor themeBackgroupColor];
    float pickerCellHeight = CGRectGetHeight(self.view.frame)/2 - 44;
    UILabel* beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 44)];
    beginLabel.text = NSLocalizedString(@"Begin Date", nil);
    decratorLabel(beginLabel);
    [self.view addSubview:beginLabel];
    
    void (^setSubviewFrame)(UIView*,UIView*,CGFloat height)= ^(UIView* currentView, UIView* preView, CGFloat height)
    {
        currentView.frame = CGRectMake(CGRectGetMinX(preView.frame), CGRectGetMaxY(preView.frame), CGRectGetWidth(self.view.frame), height);
    };
    
    setSubviewFrame(dateBeginPicker,beginLabel,pickerCellHeight);
    [self.view addSubview:dateBeginPicker];
    
    UILabel* endLabel = [[UILabel alloc] init];
    decratorLabel(endLabel);
    setSubviewFrame(endLabel,dateBeginPicker,44);
    endLabel.text = NSLocalizedString(@"End Date", nil);
    [self.view addSubview:endLabel];
    
    setSubviewFrame(dateEndPicker, endLabel, pickerCellHeight);
    [self.view addSubview:dateEndPicker];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheDate)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSave)];
    
}
- (void) cancelSave
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) saveTheDate
{
    [self.delegate setBeginDate:dateBeginPicker.date endDate:dateEndPicker.date];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate* dateBegin = [self.delegate dateBegain];
    if (!dateBegin) {
        dateBegin = [NSDate date];
    }
    [dateBeginPicker setDate:dateBegin animated:YES];;
    NSDate* endDate = [self.delegate dateEnd];
    if (!endDate) {
        endDate = [NSDate date];
    }
    dateEndPicker.minimumDate = dateBegin;
    [dateEndPicker setDate:endDate animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
