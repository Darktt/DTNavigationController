//
//  DTNavigationController.m
//
// Copyright (c) 2013 Darktt
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
            CGFloat width = _folderBar.frame.size.width;
            
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
    BOOL isPortraitOrientation = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = isPortraitOrientation ? screen.bounds.size.height : screen.bounds.size.width;
    CGFloat height = isPortraitOrientation ? 32.0f : 44.0f;
    
    if (_folderBar.hidden) {
        frame.origin.x = -width;
        frame.size = CGSizeMake(width, height);
    } else {
        frame.size = CGSizeMake(width, height);
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
    void (^animations)(void) = ^{
        [self rotateFolderBar];
    };
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:nil];
}

- (void)setImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.view.bounds];
    
    [self.view addSubview:imageView];
    [imageView release];
}

- (UIImage *)image
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1];
    
    return imageView.image;
}

@end
