//
//  DZTimesViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTimesViewController.h"
#import "DZTimeCell.h"
#import "DZTrackTimeViewController.h"
#import "DZTimeTrackManager.h"
#import "DZPieViewController.h"
#import "PrettyTableViewCell.h"
#import "PrettyShadowPlainTableview.h"
#import "PrettyDrawing.h"
#import "DZTimeTableviewCell.h"
static CGFloat DZtimeTableViewCellHeight = 70;
#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
@interface DZLabel : UILabel
@end
@implementation DZLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}
@end
@interface DZTimesViewController () <TimeScrollerDelegate,UIScrollViewDelegate>
{
    TimeScroller* _timeScroller;
}
@property (nonatomic, strong) NSFetchedResultsController* resultsController;
@end

@implementation DZTimesViewController
@synthesize resultsController;


- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller
{
    return self.tableView;
}
- (NSDate *)dateForCell:(UITableViewCell *)cell
{
    DZTimeTableviewCell* dzCell = (DZTimeTableviewCell*)cell;
    return dzCell.dzTime.dateBegain;
}
- (void) addNewTimeTrack
{
    DZTrackTimeViewController* trackView = [[DZTrackTimeViewController alloc] init];
    [self.navigationController pushViewController:trackView animated:YES];
}

- (void) didGetShake:(NSNotification*)nc
{
    [self addNewTimeTrack];
}

- (void) showThePieChart
{
    DZPieViewController* pieChart = [[DZPieViewController alloc] init];
    [self.navigationController pushViewController:pieChart animated:YES];
}
        
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAllData];
    [self.tableView reloadData];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetShake:) name:@"shake" object:nil];

}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadAllData
{
   self.resultsController = [DZTime fetchAllGroupedBy:DZTimeSectionInditify  withPredicate:nil sortedBy:DZTimeDateBegain  ascending:NO];
    [self.tableView reloadData];
    DZLabel* headerLabel = [[DZLabel alloc] initWithFrame:CGRectMake(10, 100, CGRectGetWidth(self.view.frame)-20, 100)];
    headerLabel.textAlignment = UITextAlignmentCenter;
    self.tableView.contentInset = UIEdgeInsetsMake(-100, 0.0, 0,0);
    headerLabel.numberOfLines = 0;
    headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(0.5, 0.5);

    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"所谓修行即是做一件简单的事情\n并持之以恒";
    if ([[self.resultsController fetchedObjects] count]) {
         self.tableView.tableHeaderView = headerLabel;
        self.tableView.backgroundView = nil;
    }
    else
    {
        self.tableView.backgroundView = headerLabel;
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dz_backgroud"]];
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
    UIBarButtonItem* pieChartIem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Analyze", ) style:UIBarButtonItemStyleBordered target:self action:@selector(showThePieChart)];
    self.navigationItem.rightBarButtonItem = pieChartIem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTimeTrack)];
    if (![DZTimeTrackManager isLastTrackFinished]) {
        DZTrackTimeViewController* trackView = [[DZTrackTimeViewController alloc] init];
        [self.navigationController pushViewController:trackView animated:YES];
    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.resultsController sections] objectAtIndex:section] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.resultsController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.resultsController sections] objectAtIndex:section ] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DzTimeCell";
    DZTimeTableviewCell *cell = (DZTimeTableviewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[DZTimeTableviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.titleLabel.frame = CGRectMake(0, 0, 50, 30);
        
       
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
    DZTime* timer = [self.resultsController objectAtIndexPath:indexPath];
    NSLog(@"%@",timer.sectionInditify);
    
    NSString* (^timeStringFromSeconds)(NSInteger) = ^(NSInteger seconds)
    {
        NSInteger s = seconds % 60;
        NSInteger m = seconds/60 %60;
        NSInteger h = seconds/60/60%24;
        NSInteger d = seconds/60/60/24;
        NSMutableString* str = [NSMutableString string];
        if (d!=0) {
            [str appendFormat:@"%d%@",d,NSLocalizedString(@"天", nil)];
        }
        
        if (h!=0) {
            [str appendFormat:@"%d%@",h,NSLocalizedString(@"小时", nil)];
        }
        
        if (m!=0) {
            [str appendFormat:@"%d%@",m,NSLocalizedString(@"分钟", nil)];
        }
        if ([str isEqualToString:@""] && s==0) {
            s = 1;
        }
        if (s!=0) {
            [str appendFormat:@"%d%@",s,NSLocalizedString(@"秒", nil)];
        }
        return str;
    };
    NSLog(@"%@%@",timer.dateBegain, timer.dateEnd);
    cell.titleLabel.text = timer.type;
    cell.begainLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Begin", nil),[NSDateFormatter localizedStringFromDate:timer.dateBegain dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle]];
    
    cell.timeSpendLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Spend", nil), timeStringFromSeconds([timer.dateEnd timeIntervalSinceDate:timer.dateBegain])];
    cell.endLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"End", nil), [NSDateFormatter localizedStringFromDate:timer.dateEnd dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle]];
    cell.dzTime = timer;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_timeScroller scrollViewWillBeginDragging];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {

        [_timeScroller scrollViewDidEndDecelerating];
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [_timeScroller scrollViewDidEndDecelerating];
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DZtimeTableViewCellHeight;
}
@end
