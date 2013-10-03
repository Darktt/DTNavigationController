//
//  DTViewController.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTViewController.h"
#import "DTRelease.h"

#import "DTDemoViewController.h"

#import "DTNavigationController.h"

@interface DTViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"DTFolder Style"];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [table setDataSource:self];
    [table setDelegate:self];
    
    [self setView:table];
    
    DTRelease(table);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UITableViewCell *_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = DTAutorelease(_cell);
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Normal Style"];
    }
    
    if (indexPath.row == 1) {
        [cell.textLabel setText:@"Action Button Style"];
    }
    
    if (indexPath.row == 2) {
        [cell.textLabel setText:@"Fixed Left Home Style"];
    }
    
    if (indexPath.row == 3) {
        [cell.textLabel setText:@"Fixed Left Home And Action Button Style"];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DTFolderBarStyle style = DTFolderBarStyleNormal;
    
    if (indexPath.row == 0) {
        style = DTFolderBarStyleNormal;
    }
    
    if (indexPath.row == 1) {
        style = DTFolderBarStyleActionButton;
    }
    
    if (indexPath.row == 2) {
        style = DTFolderBarStyleFixedLeftHome;
    }
    
    if (indexPath.row == 3) {
        style = DTFolderBarStyleFixedHomeAndAtionButton;
    }
    
    DTDemoViewController *demo = [DTDemoViewController demoWithFolderNumber:0];
    [demo setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    DTNavigationController *navigation = [DTNavigationController navigationWithRootViewController:demo folderStyle:style];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

@end
