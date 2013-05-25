//
//  DTNavigationController.h
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

#import <UIKit/UIKit.h>
#import "DTFolderBar.h"
#import "DTFolderItem.h"

@interface DTNavigationController : UINavigationController

@property (nonatomic, readonly) DTFolderBar *folderBar;
@property (nonatomic, getter = isFolderBarHidden) BOOL folderBarHidden;
@property (nonatomic, getter = isActionEnable) BOOL actionEnable;

+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController;
+ (instancetype)navigationWithRootViewController:(UIViewController *)rootViewController folderStyle:(DTFolderBarStyle)folderStyle;

- (void)setFolderBarHidden:(BOOL)folderBarHidden animated:(BOOL)animated;

@end
