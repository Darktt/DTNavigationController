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

// Config File
#import "DTFolderConfig.h"

#define kUIApplicationChangeStatusBarFrameDuration 0.355

typedef void (^DTAnimationsBlock) (void);
typedef void (^DTCompletionBlock) (BOOL finshed);

@interface DTNavigationController ()
{
    UIView *blockView;
    DTFolderBar *_folderBar;
    DTFolderBarStyle _folderStyle;
    
    BOOL _actionEnable;
}

@end

@implementation DTNavigationController

#pragma mark - Initialize Class

+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController
{
    DTNavigationController *nav = [[[DTNavigationController alloc] initWithRootViewController:rootViewController folderStyle:DTFolderBarStyleNormal] autorelease];
    
    return nav;
}

+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController folderStyle:(DTFolderBarStyle)folderStyle
{
    DTNavigationController *nav = [[[DTNavigationController alloc] initWithRootViewController:rootViewController folderStyle:folderStyle] autorelease];
    
    return nav;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController folderStyle:(DTFolderBarStyle)folderStyle
{
    _folderStyle = folderStyle;
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self == nil) return nil;
    
    [self.view setAutoresizesSubviews:YES];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    
    _actionEnable = NO;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    CGRect blockViewFrame = self.navigationBar.frame;
    blockViewFrame.size.width -= 44.0f;
    
    blockView = [[[UIView alloc] initWithFrame:blockViewFrame] autorelease];
    [blockView setBackgroundColor:[UIColor clearColor]];
    [blockView setHidden:YES];
    
    if (_folderBar == nil)
        _folderBar = [[DTFolderBar folderBarWithFrame:self.navigationBar.frame style:_folderStyle] retain];
    [_folderBar.actionButton addTarget:self action:@selector(showToolBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_folderBar];
    [self.view addSubview:blockView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStatusBarFrameChange:)
                                                 name:UIApplicationWillChangeStatusBarFrameNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rotateFolderBarForAppear];
    
    [self receiveStatusBarFrameChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [_folderBar release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
        _folderBar = [[DTFolderBar folderBarWithFrame:self.navigationBar.frame style:_folderStyle] retain];
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    DTFolderItem *folderItem = nil;
    
    if (viewController.title == nil) {
        folderItem = [DTFolderItem itemWithImage:[UIImage imageNamed:kFolderItemIcon] targer:self action:@selector(tapFolderItem:)];
        
        if (_folderStyle == DTFolderBarStyleFixedLeftHome || _folderStyle == DTFolderBarStyleFixedHomeAndAtionButton) {
            [_folderBar setLeftItem:folderItem];
        } else {
            [folderItems addObject:folderItem];
            [_folderBar setFolderItems:folderItems animated:YES];
        }
    } else {
        folderItem = [DTFolderItem itemWithFolderName:viewController.title targer:self action:@selector(tapFolderItem:)];
        [folderItem.textLable setTextColor:kFolderItemTextColor];
        
        [folderItems addObject:folderItem];
        [_folderBar setFolderItems:folderItems animated:YES];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    [folderItems removeLastObject];
    
    [_folderBar setFolderItems:folderItems animated:NO];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (_folderBar.leftItem != nil) {
        [_folderBar setFolderItems:nil animated:YES];
        
        return [super popToRootViewControllerAnimated:animated];
    }
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    
    NSRange range = NSMakeRange(1, folderItems.count - 1);
    
    [folderItems removeObjectsInRange:range];
    
    [_folderBar setFolderItems:folderItems animated:YES];
    
    
    return [super popToRootViewControllerAnimated:YES];
}

- (DTFolderBar *)folderBar
{
    return _folderBar;
}

- (void)setActionEnable:(BOOL)actionEnable
{
    _actionEnable = actionEnable;
    
    [blockView setHidden:!actionEnable];
    [self setToolbarHidden:!actionEnable animated:YES];
}

- (BOOL)isActionEnable
{
    return _actionEnable;
}

#pragma mark - Button Action

- (IBAction)showToolBar:(id)sender
{
    BOOL isShow = self.toolbarHidden;
    _actionEnable = isShow;
    
    [blockView setHidden:!isShow];
    [self setToolbarHidden:!isShow animated:YES];
}

#pragma mark - Folder Bar Methods

- (void)setFolderBarHidden:(BOOL)folderBarHidden
{
    [_folderBar setHidden:folderBarHidden];
}

- (void)setFolderBarHidden:(BOOL)folderBarHidden animated:(BOOL)animated
{
    if (animated) {
         DTAnimationsBlock animations = ^{
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
        
        DTCompletionBlock completion = ^(BOOL finished){
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

- (void)rotateFolderBarForAutoRotate
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

- (void)rotateFolderBarForAppear
{
    CGRect frame = _folderBar.frame;
    BOOL isPortraitOrientation = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = isPortraitOrientation ? screen.bounds.size.width : screen.bounds.size.height;
    CGFloat height = isPortraitOrientation ? 44.0f : 32.0f;
    
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
    [sender setHightlighted:YES];
    
    if (sender == _folderBar.leftItem) {
        [self popToRootViewControllerAnimated:YES];
        
        return;
    }
    
    NSMutableArray *folderItems = [NSMutableArray arrayWithArray:_folderBar.folderItems];
    
    if (sender == folderItems.lastObject) {
        return;
    }
    
    NSUInteger index = [folderItems indexOfObject:sender];
    
    if (index == NSNotFound) {
        return;
    }
    
    NSRange range = NSMakeRange(index + 1, folderItems.count - (index + 1));
    
    [folderItems removeObjectsInRange:range];
    
    [_folderBar setFolderItems:folderItems animated:YES];
    
    if (_folderBar.style == DTFolderBarStyleFixedLeftHome || _folderBar.style == DTFolderBarStyleFixedHomeAndAtionButton) {
        index += 1;
    }
    
    UIViewController *viewComtroller = [self.viewControllers objectAtIndex:index];
    
    [self popToViewController:viewComtroller animated:YES];
}

#pragma mark - Change StatusBar Frame Method

- (void)receiveStatusBarFrameChange:(NSNotification *)sender
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect folderBarFrame = [_folderBar frame];
    
    if (statusBarFrame.size.height == 40) {
        folderBarFrame.origin.y = 40.0f;
    } else {
        folderBarFrame.origin.y = 20.0f;
    }
    
    [UIView animateWithDuration:kUIApplicationChangeStatusBarFrameDuration animations:^(){
        [_folderBar setFrame:folderBarFrame];
    }];
}

#pragma mark - Rotation View Method

- (UIView *)rotatingHeaderView
{
    return _folderBar;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    DTAnimationsBlock animations = ^{
        [self rotateFolderBarForAutoRotate];
    };
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:nil];
}

@end
