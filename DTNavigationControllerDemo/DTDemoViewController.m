//
//  DTDemoViewController.m
//  DTNavigationController
//
//  Created by Darktt on 13/5/25.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTDemoViewController.h"

#import "DTNavigationController.h"

@interface DTDemoViewController ()
{
    NSInteger _folderNumber;
}

@end

@implementation DTDemoViewController

+ (id)demoWithFolderNumber:(NSInteger)folderNumber
{
    DTDemoViewController *demo = [[[DTDemoViewController alloc] initWithFolderNumer:folderNumber] autorelease];
    
    return demo;
}

- (id)initWithFolderNumer:(NSInteger)folderNumber
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self == nil ) return nil;
    
    _folderNumber = folderNumber;
   
    if (_folderNumber == 0) {
        return self;
    }
    
    NSString *title = [NSString stringWithFormat:@"Folder %d", _folderNumber];
    [self setTitle:title];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    DTNavigationController *navigation = (DTNavigationController *)self.navigationController;
    
    if (navigation.folderBarHidden) {
        [navigation setFolderBarHidden:NO animated:YES];
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
        [cell.textLabel setText:@"Push next folder"];
    }
    
    if (indexPath.row == 1) {
        [cell.textLabel setText:@"Puth and hide folderBar"];
    }
    
    if (indexPath.row == 2) {
        [cell.textLabel setText:@"Back"];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DTNavigationController *navigation = (DTNavigationController *)self.navigationController;
    DTDemoViewController *demo = [DTDemoViewController demoWithFolderNumber:_folderNumber + 1];
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:demo animated:YES];
    }
    
    if (indexPath.row == 1) {
        [navigation setFolderBarHidden:YES animated:YES];
        [navigation pushViewController:demo animated:YES];
    }
    
    if (indexPath.row == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
