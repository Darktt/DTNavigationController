//
//  DTDetailViewController.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/29.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTDetailViewController.h"
#import "DTNavigationController.h"

@interface DTDetailViewController ()

@end

@implementation DTDetailViewController

+ (id)tableViewWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DTDetailViewController *tableViewController = [[[DTDetailViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil] autorelease];
    
    return tableViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refresh = [UIRefreshControl new];
    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refresh];
    [refresh release];
    
//    DTNavigationController *nav = (DTNavigationController *)self.navigationController;
//    [nav setFolderBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIRefresh action method

- (IBAction)refreshTableView:(id)sender
{
    [self.refreshControl endRefreshing];
    NSLog(@"Refreh!!");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        DTNavigationController *nav = (DTNavigationController *)self.navigationController;
        [nav popViewControllerAnimated:YES];
    }
    
    if (indexPath.row == 1) {
        DTDetailViewController *detail = [DTDetailViewController tableViewWithNibName:@"DTDetailViewController" bundle:nil];
        [detail setTitle:@"Detail 2"];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
