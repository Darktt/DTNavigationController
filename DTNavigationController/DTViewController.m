//
//  DTViewController.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTViewController.h"
#import "DTNavigationController.h"
#import "DTDetailViewController.h"

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setTitle:@"View Controller"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DTNavigationController *nav = (DTNavigationController *)self.navigationController;
    
    if ([nav isFolderBarHidden]) {
        [nav setFolderBarHidden:NO animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.title isEqualToString:@"Detail 3"]) {
        DTNavigationController *nav = (DTNavigationController *)self.navigationController;
        [nav setFolderBarHidden:NO animated:YES];
    }
}

- (IBAction)puth:(id)sender
{
    DTDetailViewController *tableViewController = [DTDetailViewController tableViewWithNibName:@"DTDetailViewController" bundle:nil];
    [tableViewController setTitle:@"Detail 1"];
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}

@end
