//
//  DZIndexViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-5-21.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZIndexViewController.h"

#import "DZTriangleButton.h"
#import "DZTitleView.h"
#import "UIColor+DZColor.h"
#import "DZSettings.h"
#import "DZTrackTimeViewController.h"
#import "DZTimesViewController.h"
#import "DZNumberView.h"
@interface DZIndexViewController ()
{
    DZTitleView* longestView;
    DZTitleView* mostView;
    float sandStartY;
    float sandEndY;
    NSMutableArray* animationSandArray;
    BOOL animationSandContinue;
    
    UILabel* waterLabel;
    
    DZNumberView* numberView;
    UILabel* noticeLabel;
    
}
@end

@implementation DZIndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        animationSandArray = [NSMutableArray new];
        // Custom initialization
    }
    return self;
}

- (NSString*) maxLongth
{
    NSFetchedResultsController* fetchController = [DZTime fetchAllGroupedBy:DZTimeType withPredicate:nil sortedBy:DZTimeDateBegain ascending:YES];
    float longth = 0.0;
    NSString* type = @"None";
    for (id<NSFetchedResultsSectionInfo> sectionInfo in [fetchController sections]) {
        float sumSpace = 0.0;
        for (DZTime* each in [sectionInfo objects]) {
            float timeSpace = abs([each.dateBegain timeIntervalSinceDate:each.dateEnd]);
            if (timeSpace <0.0001) {
                timeSpace = 1;
            }
            sumSpace += timeSpace;
        }
        longth = longth > sumSpace ? longth : sumSpace;
        type = longth > sumSpace ? type : [sectionInfo name];
    }
    return [NSString stringWithFormat:@"%@ %f",NSLocalizedString(type, nil), longth];
}

- (NSString*) maxCount
{
    NSArray* allTypes = [[DZSettings shareInstance] allTimeTypes];
    int count = 0;
    NSString* type = @"None";
    for (NSString* each in allTypes) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.type==%@",each];
        int countC =[DZTime countOfEntitiesWithPredicate:predicate];
        count = count > countC ? count : countC;
        type = count > countC ? type : each;
        NSLog(@"count %d %@",count, each);
    }
    
    return [NSString stringWithFormat:@"%@ %d",type,count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    DZTitleViewLayout mostViewLayout = {90.0, DZTitleViewPositionLeft};
    mostView = [[DZTitleView alloc] initWithLayout:mostViewLayout];
    mostView.titleTextLabel.backgroundColor = [UIColor themeTitleColor];
    mostView.detailTextLable.backgroundColor = [UIColor themeDetailColor];
    mostView.titleTextLabel.text = NSLocalizedString(@"The most", nil);
    
    
    
    DZTitleViewLayout longestViewLayout = {90.0, DZTitleViewPositionRight};
    longestView = [[DZTitleView alloc] initWithLayout:longestViewLayout];
    longestView.titleTextLabel.backgroundColor = [UIColor themeTitleColor];
    longestView.detailTextLable.backgroundColor = [UIColor themeDetailColor];
    longestView.titleTextLabel.text = NSLocalizedString(@"The longest", nil);

    self.view.backgroundColor = [UIColor themeBackgroupColor];
    
    mostView.frame = CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) -20, 50);
    longestView.frame = CGRectMake(10, CGRectGetMaxY(mostView.frame) + 1, CGRectGetWidth(self.view.bounds)-20, 50);
    
    [self.view addSubview:mostView];
    [self.view addSubview:longestView];
    
    DZTriangleButton* triangleButton = [[DZTriangleButton alloc] init];
    triangleButton.backgroundColor = [UIColor clearColor];
    triangleButton.frame = CGRectMake(10, CGRectGetMaxY(longestView.frame) +20, CGRectGetWidth(self.view.frame)-20, 100);
    [self.view addSubview:triangleButton];
    triangleButton.titleLabel.text = NSLocalizedString(@"记一笔", nil);
    triangleButton.triangleDirection = DZTriangleButtonDirectionDown;
    
    DZTriangleButton* triangleUpButton = [[DZTriangleButton alloc] init];
    triangleUpButton.backgroundColor = [UIColor clearColor];
    triangleUpButton.frame = CGRectMake(10, CGRectGetMaxY(triangleButton.frame), CGRectGetWidth(self.view.frame)-20, 100);
    triangleUpButton.triangleDirection = DZTriangleButtonDirectionUp;
    triangleUpButton.titleLabel.text = NSLocalizedString(@"补一笔", nil);
    [self.view addSubview:triangleUpButton];
    
    [triangleUpButton addTarget:self action:@selector(startAniamtion) forControlEvents:UIControlEventTouchDown];
    
    [triangleUpButton addTarget:self action:@selector(stopAnimationaa) forControlEvents:UIControlEventTouchUpInside];
    
    
    [triangleButton addTarget:self action:@selector(startAniamtion) forControlEvents:UIControlEventTouchDown];
    
    [triangleButton addTarget:self action:@selector(stopAnimationaa) forControlEvents:UIControlEventTouchUpInside];
    [triangleButton addTarget:self action:@selector(addNewTimeTrack) forControlEvents:UIControlEventTouchUpInside];
    sandStartY = CGRectGetMinY(triangleButton.frame);
    sandEndY = CGRectGetMaxY(triangleUpButton.frame)-3;
    
    waterLabel = [UILabel new];
    waterLabel.frame = CGRectMake(CGRectGetMinX(triangleUpButton.frame), CGRectGetMaxY(triangleUpButton.frame) + 20, CGRectGetWidth(triangleUpButton.frame), 50);
    waterLabel.text = NSLocalizedString(@"流水", nil);
    [self.view addSubview:waterLabel];
    waterLabel.backgroundColor = [UIColor themeDetailColor];
    waterLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWaterLog)];
    [waterLabel addGestureRecognizer:tapGestrue];
    
    
    noticeLabel = [UILabel new];
    noticeLabel.frame = CGRectMake(CGRectGetMinX(triangleUpButton.frame), CGRectGetMaxY(waterLabel.frame) + 20, CGRectGetWidth(triangleUpButton.frame), 50);
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = NSLocalizedString(@"所谓修行即是做一件简单的事情并持之以恒", nil);
    [self.view addSubview:noticeLabel];
    noticeLabel.backgroundColor = [UIColor clearColor];
    
     numberView= [DZNumberView new];
    numberView.frame = CGRectMake(0, CGRectGetMaxY(waterLabel.frame), 40, 40);
    numberView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:numberView];
    
    NSTimer* time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNumberView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
	// Do any additional setup after loading the view.
}

- (void) updateNumberView
{
    static int i = 0;
    numberView.number = i++;
}
- (void) addNewTimeTrack
{
    DZTrackTimeViewController* trackView = [[DZTrackTimeViewController alloc] init];
    [self.navigationController pushViewController:trackView animated:YES];
}
- (void) stopAnimationaa
{
    animationSandContinue = NO;
    for (UIView* aview in animationSandArray) {
        [aview.layer removeAllAnimations];
        aview.hidden = YES;
    }
}
- (void) showWaterLog
{
    DZTimesViewController* vc = [[DZTimesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) startAnimationForView:(UIView*)aview
{
    CGRect startFrame = aview.frame;
    [UIView animateWithDuration:rand()%6 animations:^{
        aview.frame = CGRectMake(CGRectGetMinX(aview.frame), sandEndY, 1, 1);
    } completion:^(BOOL finished) {
        aview.frame = startFrame;
        if (animationSandContinue) {
           [self startAnimationForView:aview]; 
        }
    }];
}

- (void) startAniamtion
{
    animationSandContinue = YES;
    int count = [animationSandArray count];
    for (int i = count; i < 1000; ++i) {
        UIView* aView = [UIView new];
        aView.backgroundColor = [UIColor themeSandColor];
        [self.view insertSubview:aView atIndex:0];
        float startX = rand()%(int)floor(CGRectGetWidth(self.view.frame));
        if (startX < 10) {
            startX = 10;
        }
        if (startX > 310) {
            startX = 310;
        }
        aView.frame = CGRectMake(startX, sandStartY, 1, 1);
        [animationSandArray addObject:aView];
    }
    for (UIView* each in animationSandArray) {
        each.hidden = NO;
        [self startAnimationForView:each];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    longestView.detailTextLable.text = [self maxLongth];
    mostView.detailTextLable.text = [self maxCount];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
