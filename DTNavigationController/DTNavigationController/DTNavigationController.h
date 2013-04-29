//
//  DTNavigationController.h
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTFolderBar.h"

@class DTFolderBar;

@interface DTNavigationController : UINavigationController

@property (nonatomic, getter = isFolderBarHidden) BOOL folderBarHidden;
@property (nonatomic, readonly) DTFolderBar *folderBar;

+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController;

- (void)setFolderBarHidden:(BOOL)folderBarHidden animated:(BOOL)animated;

@end
