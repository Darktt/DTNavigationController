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
    
    [self.view setAutoresizesSubviews:YES];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (_folderBar == nil)
        _folderBar = [DTFolderBar folderBarWithFrame:self.navigationBar.frame];
    [_folderBar setAutoresizingMask:self.navigationBar.autoresizingMask];
    
    [self.view addSubview:_folderBar];
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
    
    if (_folderBar == nil)
        _folderBar = [DTFolderBar folderBarWithFrame:self.navigationBar.frame];
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    DTFolderItem *folderItem = nil;
    
    if ([viewController.title isEqualToString:@"Root"]) {
        folderItem = [DTFolderItem itemWithImage:[UIImage imageNamed:@"Home.png"] targer:self action:@selector(tapFolderItem:)];
    } else {
        folderItem = [DTFolderItem itemWithFolderName:viewController.title targer:self action:@selector(tapFolderItem:)];
    }
    
    [folderItem setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [folderItem setAutoresizesSubviews:YES];
    
    
    [folderItems addObject:folderItem];
    
    [_folderBar setFolderItems:folderItems animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self setFolderBarHidden:NO animated:YES];
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:self.folderBar.folderItems];
    [folderItems removeLastObject];
    
    [_folderBar setFolderItems:folderItems animated:NO];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:self.folderBar.folderItems];
    NSRange range = NSMakeRange(1, folderItems.count - 1);
    
    [folderItems removeObjectsInRange:range];
    
    [_folderBar setFolderItems:folderItems animated:YES];
    
    return [super popToRootViewControllerAnimated:YES];
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
        void (^animations) (void) = ^{
            CGRect folderBarFrame = _folderBar.frame;
            CGFloat width = _folderBar.frame.size.width; //self.navigationBar.frame.size.width;
            
            if (folderBarHidden) {
                folderBarFrame.origin.x -= width;
            } else {
                [_folderBar setHidden:folderBarHidden];
                folderBarFrame.origin.x += width;
            }
            
            [_folderBar setFrame:folderBarFrame];
        };
        
        void (^completion) (BOOL finished) = ^(BOOL finished){
            if(folderBarHidden)[self setFolderBarHidden:folderBarHidden];
        };
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:animations completion:completion];
        return;
    }
    
    [self setFolderBarHidden:folderBarHidden];
}

- (BOOL)isFolderBarHidden
{
    return [_folderBar isHidden];
}

- (void)rotateFolderBar
{
    CGRect frame = _folderBar.frame;
    BOOL orientation = !UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = orientation ? screen.bounds.size.height : screen.bounds.size.width;
    CGFloat hight = orientation ? 44.0f : 32.0f;
    
    if (_folderBar.hidden) {
        frame.origin.x = -self.navigationBar.frame.size.width;
        frame.size = CGSizeMake(width, hight);
    } else {
        frame = CGRectMake(0, 20, width, hight);
    }
    
    [_folderBar setFrame:frame];
}

#pragma mark - Tap Folder Item Method

- (IBAction)tapFolderItem:(DTFolderItem *)sender
{
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    NSUInteger index = [folderItems indexOfObject:sender];
    
    if (index == NSNotFound) {
        return;
    }
    
    if ((index + 1) == folderItems.count) {
        return;
    }
    
    NSRange range = NSMakeRange(index + 1, folderItems.count - (index + 1));
    
    [folderItems removeObjectsInRange:range];
    
    [_folderBar setFolderItems:folderItems animated:YES];
    
    UIViewController *viewComtroller = [self.viewControllers objectAtIndex:index];
    
    [self popToViewController:viewComtroller animated:YES];
}

#pragma mark - Rotation view method

- (UIView *)rotatingHeaderView
{
    return _folderBar;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self rotateFolderBar];
}

@end
