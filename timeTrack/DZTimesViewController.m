//
//  DZTimesViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-5.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZTimesViewController.h"
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"
#import "DZTimeCell.h"
#import "DZTrackTimeViewController.h"
#import "DZTimeTrackManager.h"
#import "DZPieViewController.h"
@interface DZTimesViewController ()<JTTableViewGestureAddingRowDelegate>
{
    NSMutableArray* timeMArray;
}
@property (nonatomic, strong) JTTableViewGestureRecognizer* tableGesturRecognizer;
@end

@implementation DZTimesViewController
@synthesize tableGesturRecognizer;
- (void) gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timeMArray insertObject:@"Add new" atIndex:indexPath.row];
}
- (void) gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZTrackTimeViewController* trackView = [[DZTrackTimeViewController alloc] init];
    [self.navigationController pushViewController:trackView animated:YES];
}

- (void) gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timeMArray removeObjectAtIndex:indexPath.row];
}

- (void) updateTime:(NSTimer*)timer
{
    DZTime* time = [timeMArray objectAtIndex:0];
    time.dateEnd = [NSDate date];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void) didGetShake:(NSNotification*)nc
{
    DZTrackTimeViewController* trackView = [[DZTrackTimeViewController alloc] init];
    [self.navigationController pushViewController:trackView animated:YES];
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
        timeMArray = [NSMutableArray array];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetShake:) name:@"shake" object:nil];
    [super viewWillAppear:animated];
    [self reloadAllData];
    [self.tableView reloadData];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadAllData
{
    [timeMArray removeAllObjects];
    [timeMArray addObjectsFromArray:[DZTime findAllSortedBy:@"dateBegain" ascending:NO]];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableGesturRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
    UIBarButtonItem* pieChartIem = [[UIBarButtonItem alloc] initWithTitle:@"pie" style:UIBarButtonItemStyleBordered target:self action:@selector(showThePieChart)];
    self.navigationItem.rightBarButtonItem = pieChartIem;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeMArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id obj = [timeMArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[DZTime class]]) {
        static NSString *CellIdentifier = @"DzTimeCell";
        DZTimeCell *cell = (DZTimeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[DZTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        DZTime* timer = [timeMArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %f", timer.type,[timer.dateEnd timeIntervalSinceDate:timer.dateBegain]];
        
        return cell;
    }
    else if ([obj isKindOfClass:[NSString class]])
      {
          static NSString *CellIdentifier = @"Cell";
          
          UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          
          if (!cell) {
              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          }
          cell.textLabel.text = obj;
          return cell;
      }
    else
    {
        return nil;
    }
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

@end
