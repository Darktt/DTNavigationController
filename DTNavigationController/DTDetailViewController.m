//
//  DTDetailViewController.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/29.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTDetailViewController.h"
#import "DTNavigationController.h"
#import "DTViewController.h"

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
    [refresh setTintColor:[UIColor redColor]];
    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refresh];
    [refresh release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIRefresh action method

- (IBAction)refreshTableView:(id)sender
{
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
    NSLog(@"Refreh!!");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Push to next folder"];
    }
    
    if (indexPath.row == 1) {
        [cell.textLabel setText:@"Push to next folder with hide folder bar"];
        [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingHead];
    }
    
    if (indexPath.row == 2) {
        [cell.textLabel setText:@"Pop to root View"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        DTViewController *viewController = [[DTViewController alloc] initWithNibName:@"DTViewController" bundle:nil];
        [viewController setTitle:@"Detail 2"];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
    if (indexPath.row == 1) {
        DTViewController *viewController = [[DTViewController alloc] initWithNibName:@"DTViewController" bundle:nil];
        [viewController setTitle:@"Detail 3"];
        
        DTNavigationController *nav = (DTNavigationController *)self.navigationController;
        [nav setFolderBarHidden:YES animated:YES];
        [nav pushViewController:viewController animated:YES];
        [viewController release];
    }
    
    if (indexPath.row == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
