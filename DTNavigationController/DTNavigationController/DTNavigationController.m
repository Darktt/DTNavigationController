//
//  DTNavigationController.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTNavigationController.h"

@interface DTNavigationController ()
{
    DTFolderBar *_folderBar;
}

@end

@implementation DTNavigationController

+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController
{
    DTNavigationController *nav = [[[DTNavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    
    return nav;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self == nil) return nil;
    
    [self.navigationBar setTintColor:[UIColor blackColor]];
    
    if (_folderBar == nil)
    _folderBar = [DTFolderBar folderBarWithFrame:self.navigationBar.frame];
    
    [self.view addSubview:_folderBar];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [_folderBar release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
//    NSLog(@"%s", __func__);
    
    if (_folderBar == nil)
        _folderBar = [DTFolderBar folderBarWithFrame:self.navigationBar.frame];
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    
    DTFolderItem *folderItem = [DTFolderItem itemWithFolderName:viewController.title targer:self action:@selector(tapFolderItem:)];
    
    [folderItems addObject:folderItem];
    
    [_folderBar setFolderItems:folderItems animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
//    NSLog(@"%s", __func__);
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:self.folderBar.folderItems];
    [folderItems removeLastObject];
    
    [self.folderBar setFolderItems:folderItems animated:NO];
    
    return [super popViewControllerAnimated:animated];
}

- (DTFolderBar *)folderBar
{
    return _folderBar;
}

#pragma mark - Folder Bar Methods

- (void)setFolderBarHidden:(BOOL)folderBarHidden
{
    [_folderBar setHidden:folderBarHidden];
}

- (void)setFolderBarHidden:(BOOL)folderBarHidden animated:(BOOL)animated
{
    if (animated) {
        void (^animations) (void) = ^(void){
            CGRect folderBarFrame = _folderBar.frame;
            
            if (folderBarHidden) {
                folderBarFrame.origin.x -= _folderBar.frame.size.width;
            } else {
                [_folderBar setHidden:folderBarHidden];
                folderBarFrame.origin.x += _folderBar.frame.size.width;
            }
                
            
            [_folderBar setFrame:folderBarFrame];
        };
        
        void (^completion) (BOOL finished) = ^(BOOL finished){ if(folderBarHidden)[self setFolderBarHidden:folderBarHidden]; };
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:animations completion:completion];
        return;
    }
    
    [self setFolderBarHidden:folderBarHidden];
}

- (BOOL)isFolderBarHidden
{
    return [_folderBar isHidden];
}

#pragma mark - Tap Folder Item Method

- (IBAction)tapFolderItem:(DTFolderItem *)sender
{
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    NSUInteger index = [folderItems indexOfObject:sender];
    
    if ((index + 1) == folderItems.count) {
        return;
    }
    
    NSRange range = NSMakeRange(index + 1, folderItems.count - (index + 1));
    
    [folderItems removeObjectsInRange:range];
    
    [_folderBar setFolderItems:folderItems];
    
    UIViewController *viewComtroller = [self.viewControllers objectAtIndex:index];
    
    [self popToViewController:viewComtroller animated:YES];
}

@end
