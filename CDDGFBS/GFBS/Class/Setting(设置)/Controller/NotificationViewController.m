//
//  NotificationViewController.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationItem.h"
#import "NotificationCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const notificationID = @"myNotification";

@interface NotificationViewController ()

/*所有notification数据*/
@property (strong , nonatomic)NSMutableArray<NotificationItem *> *myNotifications;
/*maxtime*/
@property (strong , nonatomic)NSString *maxtime;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation NotificationViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _manager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setUpData];
    [self setUpTable];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpData {
    NSArray *textArray = [[NSArray alloc] initWithObjects:@"Reminder. You have 3 upcoming events", @"Lolo Chan wrote a review about you", @"Reminder. You have 3 upcoming events", @"Reminder. You have 3 upcoming events", @"Reminder. You have 3 upcoming events", @"Reminder. You have 3 upcoming events", @"Reminder. You have 3 upcoming events", @"Reminder. You have 3 upcoming events",  nil];
    NSArray *timeArray = [[NSArray alloc] initWithObjects:@"An hour ago", @"2 hours ago", @"2n hour ago", @"3 hour ago",  @"3 hour ago", @"3 hour ago", @"3 hour ago", @"3 hour ago",  nil ];
    NSArray *checkedArray = [[NSArray alloc] initWithObjects:@"1", @"0", @"1", @"0", @"0", @"1", @"0", @"1", nil];
    
    NSMutableArray<NotificationItem *> *myNotifications = [[NSMutableArray<NotificationItem *> alloc] init];
    self.myNotifications = myNotifications;
    for (int i = 0; i < 8; i++) {
        NotificationItem *thisNotification = [[NotificationItem alloc] init];
        thisNotification.notificationText = [textArray objectAtIndex:i];
        thisNotification.notificationTime = [timeArray objectAtIndex:i];;
        thisNotification.checked = [checkedArray objectAtIndex:i];
        [_myNotifications insertObject:thisNotification atIndex:i];
    }
    NSLog(@"notification array %@", _myNotifications);
}

-(void)setUpTable
{
    
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.backgroundColor = GFBgColor;
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NotificationCell class]) bundle:nil] forCellReuseIdentifier:notificationID];
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //GFTopic *topic = _topics[indexPath.row];
    
    return 60.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationID forIndexPath:indexPath];
    
    NotificationItem *thisNotification = self.myNotifications[indexPath.row];
    NSLog(@"thisNotification %@", thisNotification);
    cell.notification = thisNotification;
    
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
