//
//  DZSettingsViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-24.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZSettingsViewController.h"
#import "CloudReview.h"
#import "DZGuidViewController.h"
#import <MessageUI/MessageUI.h>
@interface DZSettingsViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray* titlesArray;
}
@end

@implementation DZSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) settingDone
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titlesArray count];
}

   
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
    titlesArray = @[@[NSLocalizedString(@"Help Manual", nil)],
                    @[NSLocalizedString(@"Rate TimeTrack", nil)],
                    @[NSLocalizedString(@"Feedback", nil)]];
    [self.tableView setMoodBackgroud];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(settingDone)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[titlesArray objectAtIndex:section] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"1Cell";
    PrettyCustomViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyCustomViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"If you feel this app good , please rate it in apple store. And let others use it.", nil);
    }
    else if (section == 2)
    {
        return NSLocalizedString(@"There are something i want the developer to konw. bugs or something can be enhanceed", nil);
    }
    return @"";
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
- (void) sendFeedback
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailPocker = [[MFMailComposeViewController alloc] init];
        mailPocker.mailComposeDelegate = self;
        [mailPocker setSubject:[NSString stringWithFormat:@"[%@] %@ ",[[UIDevice currentDevice] model],NSLocalizedString(@"Feedback", nil)]];
        NSArray* toRecipients = [NSArray arrayWithObjects:@"yishuiliunian@gmail.com",nil];
        NSString* mailBody = [NSString stringWithFormat:@"%@:\n\n\n\n\n\n\n\n\n\n\n\n\n\n %@\n %@ \n"
                              ,NSLocalizedString(@"Your advice:", nil)
                              ,[[UIDevice currentDevice] systemName]
                              ,[[UIDevice currentDevice] systemVersion]
                              ];
        [mailPocker setToRecipients:toRecipients];
        [mailPocker setMessageBody:mailBody isHTML:NO];
        mailPocker.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController: mailPocker animated:YES];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL (^indexPathIsEqual)(NSInteger,NSInteger) =^(NSInteger section , NSInteger row)
    {
        return (BOOL)(indexPath.section == section && row == indexPath.row);
    };
    if (indexPathIsEqual(1, 0)) {
        [[CloudReview sharedReview] reviewFor:607603885];
    }
    else if (indexPathIsEqual(0,0))
    {
        DZGuidViewController* guidCon = [[DZGuidViewController alloc] init];
        UINavigationController* guidNav = [[UINavigationController alloc] initWithRootViewController:guidCon];
        [self.navigationController presentModalViewController:guidNav animated:YES];
    }
    else if (indexPathIsEqual(2,0))
    {
        [self sendFeedback];
    }
}

@end
